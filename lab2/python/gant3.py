import matplotlib.pyplot as plt
from collections import defaultdict

# Dane wejściowe
input_data = """
           | 0123456789
========================
        M1 | .....6.99
        M2 | 3144777..
        M3 | 225888888
"""

# Parsowanie danych
lines = [line.strip() for line in input_data.strip().split("\n")][2:]
machines = []
timeline = []

for line in lines:
    if '|' in line:
        machine, schedule = line.split('|')
        machines.append(machine.strip())
        timeline.append(schedule.strip())

# Generowanie danych do wykresu
tasks = defaultdict(list)
colors = {}
color_map = plt.cm.get_cmap('tab10')
color_idx = 0

for m_idx, row in enumerate(timeline):
    current_char = None
    start = None
    for t, char in enumerate(row):
        if char != '.' and char != current_char:
            if current_char is not None:
                tasks[(machines[m_idx], current_char)].append((start, t))
            current_char = char
            start = t
        elif char == '.' and current_char is not None:
            tasks[(machines[m_idx], current_char)].append((start, t))
            current_char = None
            start = None
    if current_char is not None:
        tasks[(machines[m_idx], current_char)].append((start, len(row)))

    # Rejestracja kolorów
    for _, op in tasks:
        if op not in colors:
            colors[op] = color_map(color_idx)
            color_idx += 1

# Rysowanie wykresu
fig, ax = plt.subplots(figsize=(10, 3))
yticks = []
yticklabels = []

for idx, machine in enumerate(machines):
    yticks.append(idx)
    y = idx
    yticklabels.append(machine)
    temp = tasks.items()
    for (m, op), spans in temp:
        if m == machine:
            for start, end in spans:
                ax.broken_barh([(start, end - start)], (y - 0.4, 0.8),
                               facecolors=colors[op], label=op)

# Legenda bez duplikatów
handles, labels = plt.gca().get_legend_handles_labels()
temp = [x for x in zip(labels, handles)]
temp.sort(key=lambda x: x[0])
by_label = dict(temp)
ax.legend(by_label.values(), by_label.keys(), title="Operacje", fontsize=10)

ax.set_xlabel("Czas")
ax.set_ylabel("Maszyna")
ax.set_xticks([0,1,2,3,4,5,6,7,8,9,10])
ax.set_yticks(yticks)
ax.set_yticklabels(yticklabels)
ax.grid(True)
plt.tight_layout()
plt.savefig("./plots/zad3.png")
