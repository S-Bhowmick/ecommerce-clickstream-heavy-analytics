# Ecommerce Clickstream Heavy Analytics – Executive Summary

## 1. Dataset Overview
This project analyzes an ecommerce clickstream dataset containing **500,000 user events**, stored in Parquet format and queried using **DuckDB** for high-performance analytics.

The dataset tracks the complete user journey:
- page_view
- product_view
- add_to_cart
- checkout
- purchase (expected)

Each event is associated with a user and includes pricing data where applicable.

---

## 2. Funnel Health Analysis
A full funnel analysis revealed a **critical breakdown at the purchase stage**.

| Funnel Stage | Users |
|-------------|-------|
| Page View | ~125,000 |
| Product View | ~125,000 |
| Add to Cart | ~125,000 |
| Checkout | ~124,000 |
| Purchase | **0** |

### Key Insight
Despite strong engagement through checkout, **no purchase events are recorded**.  
This indicates either:
- Broken purchase tracking
- Failed checkout/payment flow
- Purchases occurring outside this system

This represents a **high-severity business risk**.

---

## 3. User Behavior Segmentation
Users were segmented based on their deepest funnel interaction:

| Segment | Approx. Users | Description |
|-------|---------------|------------|
| Browsing Only | ~125K | Low intent users |
| Cart Abandoners | ~125K | High intent, high friction |
| Checkout Drop | ~124K | Payment or trust issues |
| Bounce Risk | ~125K | Poor landing experience |

### Insight
**Cart abandoners and checkout drop users represent the highest revenue recovery opportunity.**

---

## 4. Revenue & Lifetime Value Insights
- **Average Order Value (AOV):** ~254.77
- Revenue follows the **Pareto Principle**:
  - Top 10% users generate a disproportionate share of revenue
  - Bottom 90% contribute significantly less per user

This confirms the importance of **high-value user targeting and retention**.

---

## 5. Churn Revenue Impact
Revenue impact analysis by churn segment shows:

| Segment | Revenue Impact |
|-------|----------------|
| Checkout Drop | Very High |
| Cart Abandoner | High |
| Bounce Risk | Medium |
| Browsing Only | Low |

Even small improvements in checkout completion could unlock **millions in recoverable revenue**.

---

## 6. Business Recommendations

### Priority 1: Fix Purchase Tracking
Accurate purchase events are mandatory for:
- Revenue reporting
- LTV calculation
- Conversion measurement

### Priority 2: Reduce Cart & Checkout Friction
- Simplify checkout steps
- Improve payment reliability
- Add trust signals (refunds, security badges)
- Retarget abandoned users

### Priority 3: Focus on High-Value Users
- Personalized offers
- Loyalty programs
- Retention campaigns for top 10%

---

## 7. Metrics Leadership Should Monitor
- Checkout → Purchase Conversion Rate
- Cart Abandonment Rate
- Average Order Value (AOV)
- Revenue per Active User
- Cohort Retention Trends

---

## 8. Why This Project Matters
This project demonstrates:
- Heavy-data SQL analytics
- Funnel and cohort analysis
- Revenue concentration (Pareto analysis)
- Churn and revenue impact modeling
- Business-driven decision making

This mirrors real-world analytics work performed in production ecommerce systems.
