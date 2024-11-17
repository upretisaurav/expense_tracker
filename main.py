from flask import Flask, request, jsonify
import pandas as pd
from statsmodels.tsa.seasonal import seasonal_decompose
import uuid


app = Flask(__name__)

users = {}

# # Trend analysis function
# def perform_trend_analysis(expense_data):
#     """
#     Perform trend analysis on expense data
#     :param expense_data: List of expense records with 'date' and 'amount'
#     :return: Trend analysis results
#     """
#
#     df = pd.DataFrame(expense_data)
#     df['date'] = pd.to_datetime(df['date'])
#     daily_expense = df.groupby('date')['amount'].sum().reset_index()
#     daily_expense.set_index('date', inplace=True)
#     daily_expense = daily_expense.resample('D').sum()
#     decomposition = seasonal_decompose(daily_expense['amount'], model='additive', period=5)
#     trend = decomposition.trend.dropna().tolist()
#     dates = decomposition.trend.dropna().index.strftime('%Y-%m-%d').tolist()
#     return {
#         "dates": dates,
#         "trend": trend,
#         "original": daily_expense['amount'].tolist()
#     }

def perform_trend_analysis(expense_data):
    """
    Perform trend analysis on expense data as provided without assuming a specific frequency.
    :param expense_data: List of expense records with 'date' and 'amount'.
    :return: Trend analysis results.
    """

    df = pd.DataFrame(expense_data)
    df['date'] = pd.to_datetime(df['date'])
    df.sort_values(by='date', inplace=True)

    df.set_index('date', inplace=True)

    df['amount'].fillna(0, inplace=True)

    num_points = len(df)
    if num_points < 3:
        raise ValueError("Insufficient data for trend analysis. At least 3 observations are required.")

    period = max(2, num_points // 2)

    decomposition = seasonal_decompose(df['amount'], model='additive', period=period)

    trend = decomposition.trend.dropna().tolist()
    dates = decomposition.trend.dropna().index.strftime('%Y-%m-%d').tolist()

    return {
        "dates": dates,
        "trend": trend,
        "original": df['amount'].tolist()
    }


def recommend_cutting_expenses(expense_data):
    """
    Recommend categories to cut spending based on historical expense data.
    """
    df = pd.DataFrame(expense_data)
    df['date'] = pd.to_datetime(df['date'])
    category_totals = df.groupby('category')['amount'].sum().reset_index()

    # Define a threshold for overspending
    threshold = category_totals['amount'].mean() + category_totals['amount'].std()

    recommendations = category_totals[category_totals['amount'] > threshold]
    return recommendations.to_dict(orient='records')


@app.route('/recommend-expense-cut', methods=['POST'])
def recommend_expense_cut():
    expense_data = request.json.get('expenses', [])
    if not expense_data:
        return jsonify({"error": "No expense data provided"}), 400

    try:
        recommendations = recommend_cutting_expenses(expense_data)
        return jsonify({"recommendations": recommendations}), 200
    except Exception as e:
        return jsonify({"error": f"Unexpected error: {str(e)}"}), 500


@app.route('/trend-analysis', methods=['POST'])
def trend_analysis():
    expense_data = request.json.get('expenses', [])
    if not expense_data:
        return jsonify({"error": "No expense data provided"}), 400

    try:
        analysis_result = perform_trend_analysis(expense_data)
        return jsonify(analysis_result), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 400
    except Exception as e:
        return jsonify({"error": f"Unexpected error: {str(e)}"}), 500


@app.route('/signup', methods=['POST'])
def signup():
    """
    Sign up a new user.
    Request JSON should contain:
    - name: str
    - profession: str
    - photo: str (URL or Base64 string)
    - email: str
    - password: str
    """
    data = request.json
    required_fields = ['name', 'profession', 'photo', 'email', 'password']

    # Validate input
    if not all(field in data for field in required_fields):
        return jsonify({"error": "All fields are required: name, profession, photo, email, password"}), 400

    if data['email'] in users:
        return jsonify({"error": "Email already registered"}), 400

    # Save user
    user_id = str(uuid.uuid4())  # Generate unique user ID
    users[data['email']] = {
        "id": user_id,
        "name": data['name'],
        "profession": data['profession'],
        "photo": data['photo'],
        "password": data['password']  # Note: NEVER store passwords like this in a real app
    }

    return jsonify({"message": "User registered successfully", "user_id": user_id}), 201


@app.route('/signin', methods=['POST'])
def signin():
    """
    Sign in an existing user.
    Request JSON should contain:
    - email: str
    - password: str
    """
    data = request.json
    email = data.get('email')
    password = data.get('password')

    # Validate input
    if not email or not password:
        return jsonify({"error": "Email and password are required"}), 400

    user = users.get(email)
    if not user or user['password'] != password:
        return jsonify({"error": "Invalid email or password"}), 401

    return jsonify({"message": "Sign-in successful", "user_id": user['id']}), 200


@app.route('/user/<user_id>', methods=['GET'])
def get_user(user_id):
    """
    Get user details by user ID.
    """
    for email, user in users.items():
        if user['id'] == user_id:
            return jsonify({
                "name": user['name'],
                "profession": user['profession'],
                "photo": user['photo']
            }), 200
    return jsonify({"error": "User not found"}), 404


if __name__ == '__main__':
    app.run(debug=True)
