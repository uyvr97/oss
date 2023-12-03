import numpy as np
import pandas as pd
data = pd.read_csv('2019_kbo_for_kaggle_v2.csv')

#1
stat = ["H","avg","HR","OBP"]
for year in range(2015,2019):
    result = pd.DataFrame(columns=stat)
    data2 = data[data["p_year"]==year]
    print(year)
    for idx in stat:
        tmp = data2.sort_values(by=idx, ascending=False).head(10).batter_name.values
        result[idx]=tmp
    print(result)
    print()

#2
data2 = data[data["p_year"]==2018]
position = ["포수", "1루수", "2루수", "3루수", "유격수", "좌익수", "우익수"]
players = pd.Series(index=position, dtype='object')
for pos in position:
    tmp = data2[data2["cp"]==pos]
    players[pos] = tmp.loc[tmp["war"].idxmax(),"batter_name"]
print(players)
print()

#3
stat=["R", "H", "HR", "RBI", "SB", "war", "avg", "OBP", "SLG"]
Max = 0
for idx in stat:
    correlation = data.salary.corr(data[idx])
    if Max < correlation:
        Max = correlation
        ans = idx
print(ans)
