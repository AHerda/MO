#!/usr/bin/env python3

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

def main():
    plots_dir = "plots/"

    # Load the results
    df = pd.read_csv("results.csv")

    # ---- Print basic numeric summaries ----
    print("\n=== Summary Statistics ===\n")

    summary = df[["ratio_lp", "Cmax", "T_star"]].describe()#, "T_lp", "time_lp", "time_match"]].describe()
    print(summary.T[["min", "mean", "50%", "max"]].rename(columns={"50%": "median"}))


    print("\nWorst 5 Approximation Ratios:")
    print(df.sort_values("ratio_lp", ascending=False)[["filename", "ratio_lp"]].head())

    print("\nBest 5 (Closest to LP Bound):")
    print(df.sort_values("ratio_lp")[["filename", "ratio_lp"]].head())

    # ---- Seaborn Theme ----
    sns.set_theme(style="whitegrid", context="talk")

    # --- Plot 1: Approximation Ratio by Family (Boxplot) ---
    avg_ratio_by_family = df.groupby("subfolder")["ratio_lp"].mean().reset_index()
    max_ratio_by_family = df.groupby("subfolder")["ratio_lp"].max().reset_index()

    print("\nAverage ratio_lp by family:")
    print(avg_ratio_by_family.to_string(index=False))

    print("\nMaximum ratio_lp by family:")
    print(max_ratio_by_family.to_string(index=False))
    plt.figure(figsize=(10, 6))
    ax = sns.boxplot(
        x="subfolder", y="ratio_lp", data=df,
        palette="Set2", showfliers=False
    )
    ax.set_title("Współczynnik aproksymacji względem rodziny isntancji")
    ax.set_xlabel("Rodzina instancji")
    ax.set_ylabel("Współczynnik aproksymacji")
    plt.xticks(rotation=45, ha="right")
    plt.tight_layout()
    plt.savefig(plots_dir + "ratio_boxplot_by_family.png", dpi=300)
    plt.close()

    # --- Plot 2: Ratio Histogram ---
    plt.figure(figsize=(8, 6))
    ax = sns.histplot(df["ratio_lp"].dropna(), bins=25, kde=True, color="steelblue")
    ax.set_title("Distribution of Approximation Ratios")
    ax.set_xlabel("Cmax / LP bound")
    ax.set_ylabel("Number of Instances")
    plt.tight_layout()
    plt.savefig(plots_dir + "ratio_histogram.png", dpi=300)
    plt.close()

    # --- Plot 3: Ratio vs. Number of Jobs ---
    # --- Table: Average ratio_lp by number of jobs ---
    avg_ratio_by_jobs = df.groupby("jobs")["ratio_lp"].mean().reset_index()
    max_ratio_by_jobs = df.groupby("jobs")["ratio_lp"].max().reset_index()

    print("\nAverage ratio_lp by number of jobs:")
    print(avg_ratio_by_jobs.to_string(index=False))

    print("\nMaximum ratio_lp by number of jobs:")
    print(max_ratio_by_jobs.to_string(index=False))

    # Add average line to the scatter plot
    plt.figure(figsize=(10, 6))
    ax_avg = sns.lineplot(
        x="jobs", y="ratio_lp", data=avg_ratio_by_jobs,
        color="black", marker="o", label="Średni współczynnik"
    )
    ax = sns.scatterplot(
        x="jobs", y="ratio_lp", hue="subfolder",
        data=df, palette="tab10", alpha=0.85
    )
    ax.set_title("Współczynnik aproksymacji względem liczby zadań")
    ax.set_xlabel("Liczba zadań")
    ax.set_ylabel("Współczynnik aproksymacji")
    plt.legend(title="Rodzina instancji", bbox_to_anchor=(1.05, 1), loc="upper left")
    plt.tight_layout()
    plt.savefig(plots_dir + "ratio_vs_n_scatter.png", dpi=300)
    plt.close()

    print("\n✅ Plots saved in:", plots_dir)

if __name__ == "__main__":
    main()
