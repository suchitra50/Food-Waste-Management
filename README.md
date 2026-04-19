## 🚀 Live App

You can try the interactive Streamlit app here:  
👉 [Food Waste Management Dashboard](https://foodwastemanagementapp.streamlit.app/)

## 📌 Project Overview
This project focuses on analyzing and optimizing food donation and claims using SQL, Python, and Streamlit.  
It provides insights into food distribution, demand patterns, and provider-receiver trends to help reduce food wastage and improve allocation efficiency.

---

## ✨ Features
✅ Streamlit Web App with user-friendly interface  
✅ Filter food donations by **location, provider, and food type**  
✅ Contact food providers and receivers directly via app  
✅ CRUD Operations – Add, Update, Delete donation/claim records (demo-enabled)  
✅ 15+ SQL-powered analytical queries with visual outputs  
✅ Insights into food demand, provider contributions, and wastage trends  
## 📂 Repository Structure
FoodWasteManagement_Project_Suchitra/
│
├── data/ # Cleaned CSVs (query results)
│ ├── query01_city_provider_receiver_counts_cleaned.csv
│ ├── query02_To_contributing_provider_type_cleaned.csv
│ ├── ...
│ └── query15_peak_claim_month_cleaned.csv
│
├── screenshots/ # Dashboard screenshots
│ ├── query01_city_provider_receiver_counts.png
│ ├── query02_provider_type.png
│ ├── ...
│ └── query15_peak_claim_month.png
## ⚙️ Installation & Setup
1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/FoodWasteManagement_Project_Suchitra.git
   cd FoodWasteManagement_Project_Suchitra


Create virtual environment & install dependencies

pip install -r requirements.txt


Run the Streamlit app

streamlit run FoodWasteApp.py
│
├── FoodWasteApp.py # Streamlit application code
├── requirements.txt # Python dependencies
├── README.md # Project documentation
└── Project_Report.pdf # Final project report with insights
📊 Key Insights

Top contributing provider types: Restaurants lead donations.

Highest demand cities: South Kathryn, Adambury show high claim rates.

Most claimed food items: Rice and Soup dominate claims.

Most claimed meal type: Breakfast is the top claimed category.

Peak Claim Month: March 2025 had the highest claims (~1000).

📸 Screenshots

The project includes 20+ screenshots of dashboards and query outputs.
Query	Screenshot
City Provider/Receiver Counts	query01_city_provider_receiver_counts.png
Top Contributing Provider Type	query02_provider_type.png
All Provider Contacts	query03_provider_contacts.png
Receivers with Most Claims	query04_receivers_claims.png
Total Food Quantity	query05_total_quantity.png
City with Highest Listings	query06_city_highest_listings.png
Most Common Food Types	query07_food_types.png
Food Claims by Item	query08_food_claims.png
Provider with Most Successful Claims	query09_successful_claims.png
Claim Status Percentages	query10_claim_status.png
Avg Claim Quantity	query11_avg_claim.png
Most Claimed Meal Type	query12_meal_type.png
Quantity Donated per Provider	query13_quantity_donated.png
Most Demanded Food Type per City	query14_demanded_food.png
Peak Claim Month	query15_peak_month.png


---

        
