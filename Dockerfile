FROM jupyter/all-spark-notebook

ENV AIRFLOW_HOME=/usr/local/airflow
ENV SLUGIFY_USES_TEXT_UNIDECODE=yes
ARG VERSION
ENV AIRFLOW_VERSION=${VERSION}
LABEL airflow-version ${VERSION}

USER root
RUN apt update && apt install -y mariadb-client
USER $NB_UID
RUN pip install --upgrade pip \
    && curl -fsL https://raw.githubusercontent.com/apache/airflow/${VERSION}/requirements/requirements-python3.8.txt -o /tmp/constraints.txt \
    && pip install --no-cache-dir apache-airflow==${VERSION} -c /tmp/constraints.txt \
    && conda install --quiet --yes papermill==2.1.2 \
    && conda clean --all -f -y \
    && fix-permissions $CONDA_DIR \
    && fix-permissions /home/$NB_USER

COPY resources/airflow-wrapper.sh /usr/bin/airflow-wrapper.sh
