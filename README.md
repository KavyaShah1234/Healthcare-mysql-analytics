# Healthcare-mysql-analytics
SQL-based healthcare analytics project using MySQL (CTEs, joins, aggregations) to answer relevant business questions and provides conclusion on the result
## 🛠️ Tech Stack

- **Database:** MySQL  
- **Query Tool:** PopSQL  
- **Language:** SQL  
- **Data Processing:** Relational database operations  

---

## 📂 Dataset Description

The dataset consists of multiple relational healthcare tables used for analysis:

- `encounters` → Patient visit records  
- `patients` → Patient demographic information  
- `procedures` → Medical procedures performed  
- `payers` → Insurance / coverage information  
- `organizations` → Hospital / healthcare providers  

---

## 🧠 Key SQL Concepts Used

### 1. Aggregations
Used to summarize large datasets into meaningful business metrics such as:
- Total encounters per year  
- Average cost per payer  
- Procedure frequency distribution  

---

### 2. Joins
Used to combine data across related tables and enable multi-entity analysis such as:
- Linking patients with their encounters  
- Mapping procedures to specific encounters  
- Connecting payer information with billing data  

---

### 3. Common Table Expressions (CTEs)
Used to break complex queries into structured and readable steps.

Applied in:
- Readmission analysis  
- Multi-step filtering logic  
- Intermediate result computation for patient behavior analysis  

---

### 4. Window Functions
Used for advanced analytical queries on sequential data.

Example use case:
- `LAG()` function to compare consecutive encounters for the same patient  
- Identification of readmissions within a defined time window  

---

### 5. Date & Time Functions
Used for time-based analysis:
- `YEAR()` → yearly trends  
- `QUARTER()` → quarterly patient distribution  
- `DATEDIFF()` → readmission and duration calculations

## Dashboard Preview

![Healthcare Dashboard Preview](Hospital_Dashboard.png)
