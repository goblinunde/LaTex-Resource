import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
import sys
import warnings

# 忽略 K-Means n_init 的未来警告
warnings.filterwarnings("ignore", category=FutureWarning, module='sklearn.cluster._kmeans')


def setup_matplotlib_chinese():
    """
    设置 Matplotlib 以正确显示中文字符 (虽然本脚本主要输出文本，但保留是好习惯)。
    """
    try:
        plt.rcParams['font.sans-serif'] = ['SimHei']  # 尝试使用 SimHei 字体
        plt.rcParams['axes.unicode_minus'] = False  # 解决负号显示为方块的问题
    except Exception as e:
        print(f"注意：设置中文字体失败。错误: {e}")


def run_kmeans_analysis(df):
    """
    运行 K-Means (K=3) 聚类分析并输出结果。
    """
    print("\n--- 开始 3.2.3 节：K-Means 聚类画像分析 (K=3) ---")

    # 1. 定义并提取聚类特征 (Q4 到 Q14)
    # 假设 Q4-Q14 对应 Excel/DataFrame 中的第 10 到 20 列 (0-based 索引)
    try:
        feature_cols_short = [
            "Q4(规划)", "Q5(跟随)", "Q6(课外)", "Q7(熬夜)", "Q8(打听信息)",
            "Q9(打听进度)", "Q10(刷题)", "Q11(效率低)", "Q12(爱好)",
            "Q13(社交)", "Q14(取消社交)"
        ]
        feature_cols_original = df.columns[10:21]  # [Q4, Q5, ..., Q14]

        if len(feature_cols_short) != len(feature_cols_original):
            print("错误：短特征名列表和实际列数不匹配。")
            # 如果不匹配，就使用原始长列名
            feature_cols_short = feature_cols_original

        print(f"已选择 {len(feature_cols_original)} 个聚类特征 (Q4-Q14)。")
        data_subset = df[feature_cols_original].copy()

    except IndexError as e:
        print(f"错误: 无法根据索引 10:21 选择列。请检查Excel文件的列结构。")
        print(f"错误详情: {e}")
        return

    # 2. 数据预处理：将文本映射为数值 (1-5 李克特量表)
    likert_map = {
        "完全不符合": 1,
        "比较不符合": 2,
        "一般": 3,
        "比较符合": 4,
        "完全符合": 5
    }

    data_numeric = data_subset.apply(lambda col: col.map(likert_map))

    if data_numeric.isnull().values.any():
        print("\n警告: 文本到数值的映射产生了缺失值 (NaN)。")
        data_numeric = data_numeric.fillna(3)
        print("已使用 '一般' (3) 填充缺失值。")

    print("\n数据已映射为数值 (1-5)。")

    # 3. Z-Score 标准化
    scaler = StandardScaler()
    data_scaled = scaler.fit_transform(data_numeric)
    print("数据已进行 Z-Score 标准化。")

    # 4. 运行 K-Means 聚类 (K=3)
    # 这对应 3.2.2 节 "模型训练"
    k = 3
    kmeans = KMeans(n_clusters=k,
                    init='k-means++',
                    random_state=42,  # 确保结果可复现
                    n_init=10)

    kmeans.fit(data_scaled)

    # 5. 获取聚类结果
    cluster_labels = kmeans.labels_

    print(f"\n--- K-Means (K=3) 聚类结果 ---")

    # 6. 计算并打印每个群体的规模 (n)
    print("\n[群体规模 (n)]")
    cluster_sizes = pd.Series(cluster_labels).value_counts().sort_index()
    print(cluster_sizes)
    print("---")

    # 7. 计算并打印每个群体的特征均值 (Z-Scores)
    # 这就是你“表 3-1”中的核心数据

    # 将标准化数据转为 DataFrame 以便分析
    data_scaled_df = pd.DataFrame(data_scaled, columns=feature_cols_short)
    data_scaled_df['Cluster'] = cluster_labels

    # 按聚类分组，计算均值
    cluster_means = data_scaled_df.groupby('Cluster').mean()

    print("\n[群体特征均值 (Z-Score)] - (用于填充 表 3-1)")
    # .T (转置) 使其在控制台更易读
    print(cluster_means.T.round(2))
    print("---")


def main():
    """
    主执行函数
    """
    setup_matplotlib_chinese()

    # --- 加载数据 ---
    file_path = './date/date.xlsx'
    try:
        df = pd.read_excel(file_path)
        print(f"成功加载数据 '{file_path}'。 共有 {len(df)} 条记录。")
    except FileNotFoundError:
        print(f"错误： '{file_path}' 文件未找到。请检查文件路径。")
        sys.exit(1)
    except Exception as e:
        print(f"读取Excel文件时发生错误: {e}")
        sys.exit(1)

    # 运行模型一 (K-Means 聚类分析)
    run_kmeans_analysis(df)

    print("\n--- 脚本执行完毕 ---")
    print("请将上方输出的 [群体规模] 和 [群体特征均值] 与您报告中的 表 3-1 进行对比。")
    print("注意：代码输出的 'Cluster 0' 可能对应您报告中的 '群体1'、'群体2' 或 '群体3'，您需要根据特征均值手动匹配。")


if __name__ == "__main__":
    main()