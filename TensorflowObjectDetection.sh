## Tensorflow models/research/object_detection api

sudo apt-get install protobuf-compiler python-pil python-lxml -y
sudo apt-get install python-scipy python-matplotlib -y
sudo pip install jupyter

echo '' >> $HOME/.bashrc
echo '# Add iPython and Jupyter Path' >> $HOME/.bashrc
echo 'export PATH=$PATH:$HOME/.local/bin' >> $HOME/.bashrc

cd $HOME/Documents
mkdir Tensorflow_Models
cd Tensorflow_Models
git clone https://github.com/tensorflow/models.git

cd models/research
protoc object_detection/protos/*.proto --python_out=.

echo '# Add tensorflow models to the PYTHONPATH' >> $HOME/.bashrc
echo 'export PYTHONPATH=$PYTHONPATH:'`pwd`':'`pwd`'/slim' >> $HOME/.bashrc

