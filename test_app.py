import streamlit as st
import pandas as pd
import psycopg2
import plotly.express as px

# ---------------- CONFIG ----------------
st.set_page_config(page_title="Food Wastage System", layout="wide")

# ---------------- DB CONNECTION ----------------
def get_connection():
    return psycopg2.connect(
        host="localhost",
        database="food_wastage",
        user="postgres",
        password="jaanvika123",
        port=5432
    )

conn = get_connection()

# ---------------- QUERY FUNCTION ----------------
def run_query(query):
    return pd.read_sql(query, conn)

# ---------------- SIDEBAR ----------------
st.sidebar.title("🍱 Food Wastage System")

# ---------------- FILTERS ----------------
st.sidebar.markdown("### 🔍 Filters")

locations = ["All"] + list(run_query("SELECT DISTINCT location FROM food_listings")["location"])
providers = ["All"] + list(run_query("SELECT DISTINCT provider_id FROM providers")["provider_id"])
food_types = ["All"] + list(run_query("SELECT DISTINCT food_type FROM food_listings")["food_type"])

selected_location = st.sidebar.selectbox("📍 Location", locations)
selected_provider = st.sidebar.selectbox("🏪 Provider ID", providers)
selected_food = st.sidebar.selectbox("🍱 Food Type", food_types)

# ---------------- NAVIGATION ----------------
menu = st.sidebar.radio("Navigate", [
    "🏠 Overview",
    "📊 EDA Analysis",
    "📍 Filters",
    "🛠️ CRUD",
    "ℹ️ About"
])

# ---------------- OVERVIEW QUERY ----------------
OVERVIEW_QUERY = """
SELECT 
    f.location,
    COUNT(DISTINCT f.provider_id) AS providers,
    COUNT(DISTINCT c.receiver_id) AS receivers
FROM food_listings f
LEFT JOIN claims c ON f.food_id = c.food_id
GROUP BY f.location
ORDER BY providers DESC;
"""

# =========================
# 🏠 OVERVIEW
# =========================
if menu == "🏠 Overview":

    st.title("📊 Overview Dashboard")

    col1, col2, col3 = st.columns(3)

    total_food = run_query("SELECT COALESCE(SUM(quantity),0) FROM food_listings;").iloc[0, 0]
    total_providers = run_query("SELECT COUNT(*) FROM providers;").iloc[0, 0]
    total_receivers = run_query("SELECT COUNT(*) FROM receivers;").iloc[0, 0]

    col1.metric("🍱 Total Food", total_food)
    col2.metric("🏪 Providers", total_providers)
    col3.metric("👥 Receivers", total_receivers)

    st.markdown("---")

    df = run_query(OVERVIEW_QUERY)

    fig = px.bar(df, x="location", y=["providers", "receivers"], barmode="group")
    st.plotly_chart(fig, use_container_width=True)

# =========================
# 📊 EDA ANALYSIS
# =========================
elif menu == "📊 EDA Analysis":

    st.title("📊 SQL EDA")

    queries = {
        "Total Food": "SELECT SUM(quantity) AS total_food FROM food_listings;",
        "Location Wise Food": "SELECT location, COUNT(*) AS total FROM food_listings GROUP BY location;",
        "Meal Type": "SELECT meal_type, COUNT(*) AS total FROM food_listings GROUP BY meal_type;",
        "Claim Status": "SELECT status, COUNT(*) AS total FROM claims GROUP BY status;"
    }

    selected = st.selectbox("Choose Analysis", list(queries.keys()))

    df = run_query(queries[selected])
    st.dataframe(df)

    if df.shape[1] == 2:
        fig = px.bar(df, x=df.columns[0], y=df.columns[1])
        st.plotly_chart(fig, use_container_width=True)

# =========================
# 📍 FILTERS PAGE
# =========================
elif menu == "📍 Filters":

    st.title("🔎 Filtered Data")

    query = f"""
        SELECT * FROM food_listings
        WHERE location = '{selected_location}'
    """

    df = run_query(query)
    st.dataframe(df)

# =========================
# 🛠️ CRUD OPERATIONS
# =========================
elif menu == "🛠️ CRUD":

    st.title("🛠️ CRUD Operations")

    table = st.selectbox("Table", ["food_listings", "providers", "receivers", "claims"])
    action = st.radio("Action", ["Read", "Create", "Delete"])

    if action == "Read":
        df = run_query(f"SELECT * FROM {table} LIMIT 100;")
        st.dataframe(df)

    elif action == "Create" and table == "food_listings":

        provider_id = st.number_input("Provider ID")
        food_name = st.text_input("Food Name")
        quantity = st.number_input("Quantity")
        location = st.text_input("Location")

        if st.button("Insert"):
            cur = conn.cursor()
            cur.execute("""
                INSERT INTO food_listings(provider_id, food_name, quantity, location)
                VALUES (%s, %s, %s, %s)
            """, (provider_id, food_name, quantity, location))
            conn.commit()
            st.success("Inserted Successfully ✔")

    elif action == "Delete" and table == "food_listings":

        food_id = st.number_input("Food ID")

        if st.button("Delete"):
            cur = conn.cursor()
            cur.execute("DELETE FROM food_listings WHERE food_id=%s", (food_id,))
            conn.commit()
            st.warning("Deleted Successfully ✔")

# =========================
# ℹ️ ABOUT
# =========================
elif menu == "ℹ️ About":

    st.title("ℹ️ About Project")

    st.markdown("""
    ## 🍱 Food Wastage Management System

    ### 🚀 Features
    - SQL-based analytics
    - Provider & receiver tracking
    - Location insights
    - Interactive dashboard

    ### 🏗️ Tech Stack
    - Streamlit
    - PostgreSQL
    - Pandas
    - Plotly

    ### 🎯 Goal
    Reduce food wastage using data analytics
    """)

# ---------------- FOOTER ----------------
st.markdown("---")
st.caption("🚀 Final Production Ready Dashboard")
