import pandas as pd
import matplotlib.pyplot as plt

# --- 1. 设置 Matplotlib 以正确显示中文 ---
# (请确保您的 Python 环境中安装了支持中文的字体，例如 'SimHei' 或 'Microsoft YaHei')
plt.rcParams['font.sans-serif'] = 'SimHei'  # 是一个常用的黑体
plt.rcParams['axes.unicode_minus'] = False  # 解决负号显示为方块的问题

# --- 2. 加载数据 ---
try:
    # 修改这里：使用 pd.read_excel() 读取 .xlsx 文件
    df = pd.read_excel('./date/date.xlsx')
except FileNotFoundError:
    print("错误： 'date.xlsx' 文件未找到。请检查文件路径。")
    exit()
except Exception as e:
    print(f"读取Excel文件时发生错误: {e}")
    exit()


# --- 3. 定义相关列名 [1] ---
# 从您的数据文件中复制的确切列名
col_q15 = '15、您如何看待当前大学校园中的内卷现象'
col_q18 = '18、当您发现周围同学都在努力内卷时，您通常会采取哪种态度'
col_q11 = '11、我感觉自己花在图书馆/书桌前的时间很长，但实际有效产出的时间很短'


# --- 4. 绘图 (1): Q15 (对“内卷”的总体认知) ---
# 计算百分比
data_q15 = df[col_q15].value_counts(normalize=True) * 100
data_q15 = data_q15.sort_values(ascending=True)  # 水平条形图升序更易读

print("\n--- Q15 统计数据 ---")
print(data_q15)

# 绘图
plt.figure(figsize=(10, 6))
ax1 = data_q15.plot(kind='barh', color='skyblue')
# ax1.set_title('图 3-1：对“内卷”的总体认知 (Q15)', fontsize=14)
ax1.set_xlabel('百分比 (%)', fontsize=12)
ax1.set_ylabel('认知与态度', fontsize=12)

# 在条形图上显示百分比
for index, value in enumerate(data_q15):
    ax1.text(value, index, f' {value:.1f}%', va='center')

plt.tight_layout()
plt.show()


# --- 5. 绘图 (2): Q18 (“内卷”应对态度) ---
# 计算百分比
data_q18 = df[col_q18].value_counts(normalize=True) * 100
data_q18 = data_q18.sort_values(ascending=True)

print("\n--- Q18 统计数据 ---")
print(data_q18)

# 绘图
plt.figure(figsize=(10, 6))
ax2 = data_q18.plot(kind='barh', color='lightgreen')
# ax2.set_title('图 3-2：“内卷”应对态度 (Q18)', fontsize=14)
ax2.set_xlabel('百分比 (%)', fontsize=12)
ax2.set_ylabel('应对态度', fontsize=12)

# 在条形图上显示百分比
for index, value in enumerate(data_q18):
    ax2.text(value, index, f' {value:.1f}%', va='center')

plt.tight_layout()
plt.show()


# --- 6. 绘图 (3): Q11 (“无效内卷”的普遍性) ---
# 这是一个 5 点量表，我们需要保持其逻辑顺序
likert_order = ['完全不符合', '比较不符合', '一般', '比较符合', '完全符合']

# 计算百分比并按量表顺序排序
data_q11_raw = df[col_q11].value_counts(normalize=True) * 100
data_q11 = data_q11_raw.reindex(likert_order).fillna(0)  # 确保所有类别都存在

print("\n--- Q11 统计数据 ---")
print(data_q11)

# 计算报告中提到的“符合”的比例
try:
    agree_percent = data_q11['比较符合'] + data_q11['完全符合']
    print(f"\n“比较符合”或“完全符合”的总比例: {agree_percent:.1f}%")
except KeyError:
    print("警告：数据中缺少 '比较符合' 或 '完全符合' 的类别。")

# 绘图 (此处使用垂直条形图，因标签较短)
plt.figure(figsize=(10, 6))
ax3 = data_q11.plot(kind='bar', color='salmon')
# ax3.set_title('图 3-3：“无效内卷”的普遍性 (Q11)', fontsize=14)
ax3.set_ylabel('百分比 (%)', fontsize=12)
ax3.set_xlabel('符合程度', fontsize=12)
ax3.set_xticklabels(data_q11.index, rotation=0)  # 保持标签水平

# 在条形图上显示百分比
for i, v in enumerate(data_q11):
    ax3.text(i, v + 0.5, f'{v:.1f}%', ha='center', va='bottom')

plt.tight_layout()
plt.show()