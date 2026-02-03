import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler

# 1. Load and Preprocess Data
file_path = '338422996_按文本_大学生对校园内卷与行为关系调查_205_205.xlsx - Sheet1.csv'
df = pd.read_csv(file_path)

# Rename columns
column_mapping = {
    '1、您的性别': 'Gender',
    '2、您的年级': 'Grade',
    '3、您的专业大类': 'Major',
    '4、在开始一项重要学习任务前，我会花时间规划最优的学习路径和方法': 'Q4_Plan',
    '5、我看到室友或同学去图书馆/自习室后，会改变自己原有的休息计划，也跟着去学习': 'Q5_Follow',
    '6、我会花费时间学习超出课程要求、但与我个人兴趣或职业目标相关的知识或技能': 'Q6_Skills',
    '7、我通过“拉长学习时间”（例如熬夜、减少娱乐）来应对课业压力或竞争': 'Q7_TimeExt',
    '8、我会主动向老师、学长学姐打听关于考试、评分、加分项目等的“内部信息”': 'Q8_InfoSeek',
    '9、我会刻意打听其他同学的学习进度、作业完成情况或成绩': 'Q9_Spying',
    '10、我的学习时间集中用于能直接提高成绩（如刷题、背重点）的活动上': 'Q10_ScoreFocus',
    '11、我感觉自己花在图书馆/书桌前的时间很长，但实际有效产出的时间很短': 'Q11_Inefficient',
    '12、我每周有固定时间从事与学业竞争无关的个人爱好（如运动、艺术、社团活动）': 'Q12_Hobbies',
    '13、我每周会参加以休闲娱乐为目的的社交活动（如聚餐、看电影、闲聊）': 'Q13_Social',
    '14、因为学习，我取消了原本计划好的休闲或社交活动': 'Q14_CancelLeisure',
    '15、您如何看待当前大学校园中的内卷现象': 'Q15_View',
    '16、您认为校园内卷对您的学习动力产生了怎样的影响': 'Q16_Motivation',
    '18、当您发现周围同学都在努力内卷时，您通常会采取哪种态度': 'Q18_Reaction'
}
df_clean = df.rename(columns=column_mapping).copy()

# Likert Mapping
likert_map = {'完全不符合': 1, '比较不符合': 2, '一般': 3, '比较符合': 4, '完全符合': 5}
behavior_cols = ['Q4_Plan', 'Q5_Follow', 'Q6_Skills', 'Q7_TimeExt', 'Q8_InfoSeek',
                 'Q9_Spying', 'Q10_ScoreFocus', 'Q11_Inefficient', 'Q12_Hobbies',
                 'Q13_Social', 'Q14_CancelLeisure']
for col in behavior_cols:
    df_clean[col] = df_clean[col].map(likert_map)

# 2. Generate Plots
# Heatmap
plt.figure(figsize=(10, 8))
# Use a font that supports CJK if possible, but for simplicity in this env, we stick to default or English labels in plots
# (The user sees the image, but the LaTeX refers to it)
sns.heatmap(df_clean[behavior_cols].corr(), annot=True, cmap='coolwarm', fmt=".2f")
plt.title("Correlation Matrix")
plt.savefig("behavior_correlation.png")

# Attitude vs Behavior (Construct composite score first)
df_clean['Score_Involution'] = df_clean[['Q5_Follow', 'Q7_TimeExt', 'Q9_Spying', 'Q14_CancelLeisure']].mean(axis=1)
plt.figure(figsize=(10, 6))
# Map Q15 to English or short labels for plotting if needed, but let's keep original for now
sns.boxplot(x='Q15_View', y='Score_Involution', data=df_clean)
plt.title("Involution Behavior by Attitude")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("involution_by_attitude.png")

# 3. K-Means Clustering
# Standardize
scaler = StandardScaler()
X_scaled = scaler.fit_transform(df_clean[behavior_cols])

# KMeans k=3
kmeans = KMeans(n_clusters=3, random_state=42)
df_clean['Cluster'] = kmeans.fit_predict(X_scaled)

# Get cluster profiles (centers) in original scale (approx) or Z-score scale
# The user's table showed Z-scores (standardized values usually, or centered).
# Let's provide the Z-score centers as that highlights differences better (positive=high, negative=low).
cluster_centers = pd.DataFrame(kmeans.cluster_centers_, columns=behavior_cols)
cluster_counts = df_clean['Cluster'].value_counts(normalize=True).sort_index()

print("Cluster Percentages:")
print(cluster_counts)
print("\nCluster Centers (Z-Scores):")
print(cluster_centers.T) # Transpose for easier reading

# Assign names to clusters based on characteristics for the report
# Logic to check:
# Cluster 0, 1, 2 -> Map to "Autonomous", "Competitive", "Anxious" etc.