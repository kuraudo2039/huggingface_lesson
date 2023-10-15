# 参考
# https://qiita.com/ntatsuya/items/ef8f48d5e482d4b0f100
# https://qiita.com/shimacpyon/items/1af6d1ed69f6ad54c73c

FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

# 必要なパッケージをインストール
RUN apt update && apt install -y --no-install-recommends wget build-essential ca-certificates zlib1g-dev libbz2-dev libssl-dev libffi-dev libreadline-dev git libsqlite3-dev liblzma-dev

# build-essential ビルドツール
# libffi-dev 外部関数呼び出し
# libssl-dev SSL/TLSサポート ※pipインストール等で必要
# ca-certificates 証明書サポート ※wget等でhttpsに通信する上で必要
# 他、下記のようなライブラリが必要になる可能性あり。

# numpy と scipy:
# libblas-dev: BLAS ライブラリの開発ツール。
# liblapack-dev: LAPACK ライブラリの開発ツール。
# libatlas-base-dev: ATLAS 用のライブラリ。

# matplotlib:
# libfreetype6-dev: フォントエンジン。
# libpng-dev: PNG 画像ライブラリの開発ツール。
# + zlib1g-dev zip形式の圧縮・展開用、matplotlibが内部的に使ってるらしい。

# その他
# libreadline-dev: pythonの対話型シェル利用時に利用されることが多いreadlineライブラリ用のパッケージらしい。
# libsqlite3-dev pysqlite3 を入れるために、ubuntuにもsqlite3用パッケージを入れておく。
# liblzma-dev lzma という圧縮アルゴリズムが、pandasとか使うのに必要らしい。

# 任意バージョンのpythonをインストール
# python3.11.6 https://www.python.org/ftp/python/3.11.6/Python-3.11.6.tgz
RUN wget https://www.python.org/ftp/python/3.11.6/Python-3.11.6.tgz \
  # 現代は-zを指定しなくても、tarが勝手にgzipを解釈して解凍してくれるらしい。
  && tar -xf Python-3.11.6.tgz \
  # && ls \
  && cd Python-3.11.6 \
  # Pythonのビルド https://docs.python.org/ja/3/using/unix.html
  && ./configure --enable-optimizations \
  && make \
  && make install

RUN apt autoremove -y

# 直接requrement.txtを参照できないため、DockerfileのCOPYコマンドを使ってコンテナ内にコピー
RUN mkdir /home/src
COPY requirements.txt /home/src

# 必要なpythonパッケージをインストール
RUN pip3 install -r /home/src/requirements.txt

# jupyterlabのみpipが推奨されていたので、こちらでインストールする
RUN pip3 install jupyterlab

# ワークディレクトリに移動しておく?
# RUN cd /home/workdir