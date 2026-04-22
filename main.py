import pandas as pd
from sqlalchemy import create_engine
import matplotlib.pyplot as plt
import seaborn as sns

db_url = 'postgresql+psycopg2://postgres:1234@localhost:5432/shop_analytics'
engine = create_engine(db_url)

query = """
SELECT sale_date, total_amount
FROM sales
ORDER BY sale_date ASC;
"""

df = pd.read_sql_query(query, engine)
df['sale_date'] = pd.to_datetime(df['sale_date'])
df.set_index('sale_date', inplace=True)

daily_sales = df['total_amount'].resample('D').sum()

rolling_avg_7d = daily_sales.rolling(window=7).mean().fillna(0)
cumulative_sales = daily_sales.cumsum()

analytics_df = pd.DataFrame({
    'Дневная выручка': daily_sales,
    'Накопительный итог': cumulative_sales,
    'Тренд (7 дней)': rolling_avg_7d
})

analytics_df = analytics_df.round(2)

print("--- 1. Последние 5 дней (Дневная выручка) ---")
print(daily_sales.tail(5))
print("\n")

print("--- 2. Скользящее среднее за 7 дней (последние 5 дней) ---")
print(rolling_avg_7d.tail(5))
print("\n")

print("--- 3. Итоговая таблица динамики (последние 10 дней) ---")
print(analytics_df.tail(10))

sns.set_theme(style="darkgrid", context="notebook")
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(14, 10), sharex=True)

ax1.bar(analytics_df.index, analytics_df['Дневная выручка'], 
        color='royalblue', alpha=0.3, label='Дневная выручка')

ax1.plot(analytics_df.index, analytics_df['Тренд (7 дней)'], 
         color='crimson', linewidth=2.5, label='Тренд (7 дней)')

ax1.set_title('Динамика продаж и скользящее среднее (Тренд)', fontsize=16, fontweight='bold', pad=15)
ax1.set_ylabel('Сумма выручки', fontsize=12)
ax1.legend(loc='upper left', frameon=True)

ax2.plot(analytics_df.index, analytics_df['Накопительный итог'], 
         color='forestgreen', linewidth=2, label='Накопительный итог')

ax2.fill_between(analytics_df.index, analytics_df['Накопительный итог'], 
                 color='forestgreen', alpha=0.2)

ax2.set_title('Накопительная выручка за весь период', fontsize=16, fontweight='bold', pad=15)
ax2.set_xlabel('Дата', fontsize=12)
ax2.set_ylabel('Общая сумма (накопительно)', fontsize=12)
ax2.legend(loc='upper left', frameon=True)

plt.gcf().autofmt_xdate()
plt.tight_layout()
plt.show()