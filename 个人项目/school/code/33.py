import pandas as pd
import numpy as np
from scipy.stats import spearmanr, chi2_contingency
import sys
import warnings

# 忽略运行时可能出现的均值警告
warnings.filterwarnings("ignore", category=RuntimeWarning)


def setup_matplotlib_chinese():
    """
    设置 Matplotlib 以正确显示中文字符 (为未来绘图做准备)。
    """
    try:
        from matplotlib import pyplot as plt
        plt.rcParams['font.sans-serif'] = ['SimHei']  # 尝试使用 SimHei 字体
        plt.rcParams['axes.unicode_minus'] = False  # 解决负号显示为方块的问题
    except Exception as e:
        print(f"注意：设置中文字体失败。错误: {e}")


def run_improved_spearman_analysis(df):
    """
    运行 3.3.2 节的 *改进版* Spearman 分析。

    分析思路：不再使用 4 个“构念”，而是直接检验 10 个具体行为
    (Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q12,Q13,Q14)
    与 1 个核心结果 (Q11 "低效能") 之间的相关性。
    """
    print("\n--- 开始 3.3.2 节：Spearman 相关性分析 (改进版) ---")
    print("分析：检验 Q11(低效能) 与其他10项具体行为的相关性")

    # 1. 定义所有相关列
    # Q4(10) 到 Q14(20)
    behavior_efficacy_cols = df.columns[10:21].tolist()

    # 2. 数据预处理：将李克特量表文本映射为数值
    likert_map = {
        "完全不符合": 1,
        "比较不符合": 2,
        "一般": 3,
        "比较符合": 4,
        "完全符合": 5
    }

    # 映射所有11个列
    mapped_cols_dict = {}
    for i, col_name in enumerate(behavior_efficacy_cols):
        # 使用 Q4, Q5... 作为键
        short_name = f"Q{i + 4}"
        df[short_name] = df[col_name].map(likert_map)
        mapped_cols_dict[short_name] = col_name  # 存储 Q4 -> 原始列名

    # 填充映射后可能产生的 NaN (用 "一般"=3)
    df = df.fillna(3)

    mapped_col_names = list(mapped_cols_dict.keys())  # ['Q4', 'Q5', ..., 'Q14']

    print("已将 Q4-Q14 映射为 1-5 的数值。")

    # 3. 运行相关性分析

    # 我们的核心 outcome 变量
    outcome_var = 'Q11'

    # features 是 Q11 之外的其他变量
    feature_vars = [col for col in mapped_col_names if col != outcome_var]

    results = {}

    # 循环计算 Q11 与其他所有变量的相关性
    for feat in feature_vars:
        try:
            corr, p_value = spearmanr(df[outcome_var], df[feat])
            results[feat] = {
                'correlation (ρ)': corr,
                'p_value': p_value
            }
        except Exception as e:
            print(f"计算 {feat} 与 {outcome_var} 相关性时出错: {e}")
            results[feat] = {'correlation (ρ)': np.nan, 'p_value': np.nan}

    # 4. 打印结果
    results_df = pd.DataFrame.from_dict(results, orient='index')

    print("\n[Q11(低效能) 与各项行为的相关性矩阵]")
    # 使用 .to_string() 确保打印所有行
    print(results_df.to_string())

    print("\n[分析提示]")
    print("请查看上表。'correlation (ρ)' 为正，表示该行为与'低效能感'正相关 (即该行为越多，越感觉低效)。")
    print("'p_value' < 0.05 的项才是统计显著的。你需要用这些 *显著* 的项来重写你的报告。")

    print("\n--- Spearman 分析完成 ---")


def run_chi_square_analysis_fixed(df):
    """
    运行 3.3.3 节的 Chi-Square (卡方) 检验 (修复了逻辑错误)。
    """
    print("\n--- 开始 3.3.3 节：Chi-Square (卡方) 检验 (逻辑修复版) ---")

    # 1. 定义列
    q15_col = df.columns[21]  # Q15 (如何看待)
    q18_col = df.columns[24]  # Q18 (如何应对)

    # 2. 创建交叉列联表 (Table 3-3)
    crosstab_table = pd.crosstab(df[q15_col],
                                 df[q18_col],
                                 margins=True,
                                 margins_name="总计")

    print("\n[交叉列联表 (观测频数)] - (对应 表 3-3)")
    # 使用 .to_string() 确保打印所有行列
    print(crosstab_table.to_string())

    # 3. 运行 Chi-Square 检验
    crosstab_no_margins = pd.crosstab(df[q15_col], df[q18_col])

    try:
        chi2, p_value, dof, expected_freqs = chi2_contingency(crosstab_no_margins)

        print("\n[Chi-Square 检验结果]")
        print(f"  Chi-Square (χ²) 值: {chi2:.2f}")
        print(f"  P 值 (p-value):       {p_value}")  # 你的结果是 0.453
        print(f"  自由度 (dof):         {dof}")

        print("\n[结论 (已修复逻辑)]")
        # 修复了这里的逻辑：结论必须根据 p_value 动态变化
        if p_value < 0.05:
            print(f"  P < 0.05, 结果显著。")
            print("  结论：拒绝原假设。Q15 (认知) 与 Q18 (应对) 之间存在显著关联。")
        else:
            print(f"  P >= 0.05 (p={p_value:.3f}), 结果不显著。")
            print("  结论：未能拒绝原假设。Q15 (认知) 与 Q18 (应对) 之间未发现统计上的显著关联。")

    except ValueError as e:
        print(f"\n运行卡方检验时出错: {e}")

    print("\n--- Chi-Square 分析完成 ---")


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

    # 运行模型二的两个部分
    run_improved_spearman_analysis(df)
    run_chi_square_analysis_fixed(df)

    print("\n--- 所有分析已完成。---")
    print("警告：您的真实数据分析结果与原始报告草稿中的“预期结论”严重不符。")
    print("您必须使用本次运行的 *真实* 结果来更新您的报告。")


if __name__ == "__main__":
    main()