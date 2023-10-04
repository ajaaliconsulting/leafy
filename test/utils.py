"""
Purpose:
*.
"""
from tabulate import tabulate


def disanostics_table(diagnostics):
    table = [
        [k, *v] for k, v in diagnostics.items()
    ]
    headers = ['', *list(range(len(table[0]) - 1))]
    return tabulate(table, headers)


def dfs_diagnostics(dfs):
    return f"\n" \
            f"Cross: {dfs.cross_links}\n" \
            f"Tree: {dfs.tree_links}\n" \
            f"Down: {dfs.down_links}\n" \
            f"Back: {dfs.back_links}\n" \
            f"{disanostics_table(dfs.diagnostics)}"