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