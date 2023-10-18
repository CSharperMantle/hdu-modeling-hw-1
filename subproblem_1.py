import pandas as pd
from pprint import pprint

def maximin_group_sum(data: pd.DataFrame) -> tuple[list[list[float]], list[list[int]]]:
    data_cap = data[0:(len(data) // 3)]
    data_member = data[(len(data) // 3):]
    d_member_sorted = data_member.sort_values(by="能力值", axis=0, ascending=False).T
    a_member: list[float] = d_member_sorted.iloc[1].to_list()
    a_member_idcs: list[int] = d_member_sorted.iloc[0].astype("int").to_list()

    n_groups = len(data) // 3

    groups: list[list[float]] = [[] for _ in range(n_groups)]
    groups_idx: list[list[int]] = [[] for _ in range(n_groups)]
    idx = 0

    for i in range(len(data_cap)):
        groups[i].append(data_cap.iloc[i, 1])
        groups_idx[i].append(data_cap.iloc[i, 0])

    while len(a_member) > 0:
        idx_min = 0
        sum_min = sum(groups[0])
        for i in range(n_groups):
            if sum(groups[i]) <= sum_min:
                idx_min = i
                sum_min = sum(groups[i])
        groups[idx_min].append(a_member.pop(0))
        groups_idx[idx_min].append(a_member_idcs[idx])
        idx += 1

    return groups, groups_idx

data = pd.read_excel(input())

groups, groups_idx = maximin_group_sum(data)
pprint(groups)
pprint(groups_idx)
print(min([sum(g) for g in groups]))