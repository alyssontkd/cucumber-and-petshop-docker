#!/bin/bash
set -e

git_user='71225919134'
git_pswd='#Magatti2019#'
cucumber_dir='/usr/src/app/cucumber-glpi'
cucumber_cred_file="${cucumber_dir}/.git-credentials"
path_remote_origin='https://gitlab.poupex.com.br/poupex/qa/cucumber/glpi.git'

echo "[ ****************** ] Listando diretorio atual"
ls -la
pwd

if [ ! -e "${cucumber_dir}/Gemfile" ]; then
    echo "[ ****************** ] Starting Endpoint of Application"
    sleep 2
    echo "[ ****************** ] Application not found in ${cucumber_dir} - Cloning now..."
    mkdir -p ${cucumber_dir}
    cd ${cucumber_dir}
    git init
    git remote add origin ${path_remote_origin}

    #Cria um arquivo com as credenciais para que todos os comandos que precisem de autenticação utilize este arquivo
    git config credential.helper "store --file=${cucumber_cred_file}"
    echo "https://${git_user}:${git_pswd}@gitlab.poupex.com.br" > "${cucumber_cred_file}"
    echo "[ ****************** ] Ending Endpoint of Application"
fi

echo "[ ****************** ] Arquivo já existe e foi localizado. Acessando diretorio da aplicacao"
cd ${cucumber_dir}
pwd
git remote update
git checkout -f master
git pull origin master
git describe --tags
echo "[ ****************** ] OK! Clone Successfull!"

echo "[ ****************** ] Instalando as dependencias do Cucumber........."
cp -av /tmp/config.yml ${cucumber_dir}/features/support
cp -av /tmp/env.rb ${cucumber_dir}/features/support
#cp -av /tmp/Gemfile ${cucumber_dir}
#cp -av /tmp/Gemfile.lock ${cucumber_dir}
cp -av /tmp/cucumber.yaml ${cucumber_dir}

#bundle config --delete frozen
#bundle lock --add-platform ruby
#bundle lock --add-platform x86_64-linux
bundle update
#gem update
#cucumber

exec "$@"

