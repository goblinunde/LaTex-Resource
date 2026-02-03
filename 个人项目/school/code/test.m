$ @不会就是基准地价
** 上党课可接受的 

可接受的可接受的
if jhd kld 

	% 导入必要的库
	import pandas as pd
	
	def clean_data(df):
	"""
	清洗数据中的空值
	"""
	# 删除包含空值的行
	df_cleaned = df.dropna()
	return df_cleaned