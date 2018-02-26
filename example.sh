./serve.sh day0 8000&
./serve.sh day1 9000&

Rscript -e 'source("compare.R"); compare("http://localhost:8000", "http://localhost:9000", "sandwich")'