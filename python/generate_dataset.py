import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

random.seed(42)
np.random.seed(42)

# -------------------------
# Customers
# -------------------------

first_names = [
    "Aarav","Vivaan","Aditya","Arjun","Aryan","Vihaan","Ishaan",
    "Rohan","Rahul","Ananya","Diya","Priya","Sneha","Neha",
    "Karan","Aditi","Kabir","Meera","Riya","Saanvi"
]

last_names = [
    "Sharma","Verma","Patel","Singh","Gupta","Das",
    "Roy","Joshi","Mehta","Nair","Kumar","Yadav"
]

cities = {
    "Delhi":"North",
    "Mumbai":"West",
    "Bengaluru":"South",
    "Hyderabad":"South",
    "Chennai":"South",
    "Kolkata":"East",
    "Pune":"West",
    "Jaipur":"North",
    "Lucknow":"North",
    "Guwahati":"East"
}

states = {
    "Delhi":"Delhi",
    "Mumbai":"Maharashtra",
    "Bengaluru":"Karnataka",
    "Hyderabad":"Telangana",
    "Chennai":"Tamil Nadu",
    "Kolkata":"West Bengal",
    "Pune":"Maharashtra",
    "Jaipur":"Rajasthan",
    "Lucknow":"Uttar Pradesh",
    "Guwahati":"Assam"
}

customers = []

for i in range(1,5001):

    city = random.choice(list(cities.keys()))

    customers.append([
        f"C{i:05}",
        random.choice(first_names)+" "+random.choice(last_names),
        random.choice(["Male","Female"]),
        random.randint(18,65),
        city,
        states[city],
        cities[city]
    ])

customers_df = pd.DataFrame(customers,
columns=[
"CustomerID",
"CustomerName",
"Gender",
"Age",
"City",
"State",
"Region"
])

# -------------------------
# Products
# -------------------------

categories = {
    "Electronics":["Laptop","Phone","Headphones","Keyboard","Mouse"],
    "Furniture":["Chair","Table","Sofa","Bed","Cabinet"],
    "Office Supplies":["Notebook","Pen","Printer","Paper","Marker"]
}

products=[]

pid=1

for cat,items in categories.items():
    for item in items:
        for j in range(1,34):

            cost=random.randint(100,5000)

            products.append([
                f"P{pid:04}",
                f"{item} {j}",
                cat,
                item,
                cost
            ])

            pid+=1

products_df=pd.DataFrame(products,
columns=[
"ProductID",
"ProductName",
"Category",
"SubCategory",
"UnitCost"
])

# -------------------------
# Sales
# -------------------------

sales=[]

start=datetime(2023,1,1)

for i in range(1,50001):

    customer=customers_df.sample(1).iloc[0]
    product=products_df.sample(1).iloc[0]

    quantity=random.randint(1,5)

    unit_price=round(product["UnitCost"]*random.uniform(1.2,2.0),2)

    discount=round(random.choice([0,5,10,15,20])/100,2)

    sales_amount=round(quantity*unit_price*(1-discount),2)

    profit=round(
        sales_amount-(quantity*product["UnitCost"]),
        2
    )

    order_date=start+timedelta(days=random.randint(0,730))

    sales.append([
        f"O{i:06}",
        order_date.strftime("%Y-%m-%d"),
        customer["CustomerID"],
        product["ProductID"],
        quantity,
        unit_price,
        discount,
        sales_amount,
        profit
    ])

sales_df=pd.DataFrame(sales,
columns=[
"OrderID",
"OrderDate",
"CustomerID",
"ProductID",
"Quantity",
"UnitPrice",
"Discount",
"Sales",
"Profit"
])

# -------------------------
# Export CSVs
# -------------------------

customers_df.to_csv("customers.csv",index=False)
products_df.to_csv("products.csv",index=False)
sales_df.to_csv("sales.csv",index=False)

print("Dataset generated successfully!")
print("Customers:",len(customers_df))
print("Products:",len(products_df))
print("Sales:",len(sales_df))