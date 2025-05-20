# CMML-miniproject2
# Automatic Cell Type Annotation Benchmark (PBMC68k)

This repository contains all materials for a mini-project benchmarking automatic cell type annotation methods on the PBMC68k dataset. We evaluated three representative tools—**CellAssign**, **SingleR**, and **scANVI**—and investigated the impact of marker gene selection on CellAssign performance.

## 🧪 Project Contents

📁 cellassign/ # Local copy of CellAssign R package with source code modifications.
📄 CMML_ICA2.Rmd # Main RMarkdown report with CellAssign + SingleR analysis.
📄 scANVI.ipynb # Python notebook for scANVI annotation using scvi-tools.
📄 README.md # Project summary and usage instructions.
📄 scanvi_labels.csv #The results of scanvi, used for benchmark.

## 📊 Description

- **CellAssign** was tested with two marker gene sets (basic vs. refined) to assess the effect of marker selection on annotation outcomes.
- **SingleR** was used as a reference-based method and served as the label ground truth for benchmarking.
- **scANVI** was trained on PBMC68k using transferred labels from SingleR to evaluate semi-supervised latent modeling.

## 🖥️ System Requirements

- R version: `4.4.2`
- Python: `3.10+` with `scvi-tools`, `anndata`, `scanpy`
- TensorFlow (for CellAssign): `v1.15.5`
- GPU (for scANVI): NVIDIA RTX 3090 (recommended)
- OS: Windows 11 / Linux (tested on Intel i7-12700H + 32 GB RAM)

## 📁 Folder Details

- **`cellassign/`**  
  Includes a local copy of the CellAssign source code with a fix applied to resolve TensorFlow reshape errors.  
  📌 Patched line (in source):  
  ```r
  tf$reshape(tf$reduce_logsumexp(...), shape = c(1L, -1L))
CMML_ICA2.Rmd
RMarkdown file containing the full CellAssign + SingleR pipeline, preprocessing, UMAP/tSNE visualization, performance metrics (F1, accuracy, precision, recall), and figure generation.

scANVI.ipynb
Python notebook implementing scVI and scANVI workflows using scvi-tools. Includes anndata preparation, label integration, training, and UMAP visualization of predictions.

📈 Benchmark Summary
Method	Runtime (sec)	Accuracy	Notes
SingleR	208.29	1.00	Fast, supervised reference
CellAssign	1516.37–2977.34	0.66	Sensitive to marker selection
scANVI	~7200	0.67	GPU-based, semi-supervised

📚 References
Zhang et al., Nature Methods, 2019 – CellAssign

Aran et al., Nature Immunology, 2019 – SingleR

Xu et al., Molecular Systems Biology, 2021 – scANVI
