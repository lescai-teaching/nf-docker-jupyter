FROM jupyter/datascience-notebook

# Install the conda environment
# COPY docker_env.yml /
# RUN conda env create -f /docker_env.yml && conda clean -a
RUN conda config --system --prepend channels bioconda
RUN conda config --system --prepend channels defaults

RUN conda install --quiet --yes \
    conda-forge::biopython \
    conda-forge::numpy \
    conda-forge::matplotlib \
    conda-forge::markdown \
    conda-forge::pymdown-extensions \
    conda-forge::pygments \
    bioconda::fastqc \
    bioconda::multiqc \
    bioconda::bowtie2 \
    bioconda::samtools \
    bioconda::snpeff=4.5covid19 \
    bioconda::nextflow \
    bioconda::nf-core \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

## Add the bash kernel to python notebooks
RUN pip install --quiet --no-cache-dir bash_kernel && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
RUN python -m bash_kernel.install


USER root
RUN mkdir -p /opt/shared/DATA
WORKDIR /opt/shared/DATA
RUN apt-get install -y git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/variant_calling_data.git
RUN chown -R jovyan:users /opt/shared/DATA
USER jovyan

ENV PATH /opt/shared/envs/aws-env/bin:$PATH
ENV PYTHONPATH /opt/shared/envs/aws-env/lib/python3.8/site-packages:$PYTHONPATH