#!/bin/bash
clear
# Verificar se o comando está disponível no sistema
check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "O comando '$1' não está disponível. Instalando o pacote..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
      if ! brew install "$2"; then
        echo "Falha ao instalar o pacote '$2'."
        exit 1
      fi
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
      if ! sudo apt-get install -y "$2"; then
        echo "Falha ao instalar o pacote '$2'."
        exit 1
      fi
    else
      echo "Sistema operacional não suportado. Instale manualmente o pacote '$2'."
      exit 1
    fi
  fi
}

# Verificar e instalar os pacotes necessários
check_command "unzip" "unzip"
check_command "openssl" "openssl"

# Solicitar o caminho do arquivo ZIP
read -p "Digite o caminho do arquivo ZIP: " zip_file

# Remover espaços em branco do início e final do caminho do arquivo ZIP
zip_file=$(echo "$zip_file" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e "s/'//g")

# Verificar se o arquivo ZIP existe
if [[ ! -f "$zip_file" ]]; then
  echo "Arquivo ZIP não encontrado. Certifique-se de fornecer um caminho válido."
  exit 1
fi

# Extrair o diretório do arquivo ZIP
zip_dir=$(dirname "$zip_file")

# Extrair o nome do arquivo ZIP (sem a extensão)
zip_filename=$(basename "$zip_file")
zip_filename="${zip_filename%.*}"

# Criar uma pasta temporária
temp_folder=$(mktemp -d)

# Descompactar o arquivo ZIP na pasta temporária
unzip "$zip_file" -d "$temp_folder"

# Verificar se os arquivos foram descompactados corretamente
if [[ ! -f "$temp_folder/private.key" || ! -f "$temp_folder/certificate.crt" || ! -f "$temp_folder/ca_bundle.crt" ]]; then
```bash
  echo "Erro ao descompactar os arquivos. Verifique o conteúdo do arquivo ZIP."
  rm -rf "$temp_folder"
  exit 1
fi

# Perguntar ao usuário a senha para o certificado
read -s -p "Digite a senha para o certificado: " cert_password
echo

# Obter a data atual no formato desejado
current_date=$(date +'%Y%m%d')

# Definir o nome do arquivo PFX
pfx_filename="${zip_filename}_${current_date}.pfx"

# Caminho completo do arquivo PFX
pfx_file="${zip_dir}/${pfx_filename}"

# Converter os arquivos para formato PFX usando a senha fornecida
openssl pkcs12 -export -in "$temp_folder/certificate.crt" -inkey "$temp_folder/private.key" -certfile "$temp_folder/ca_bundle.crt" -out "$pfx_file" -password pass:"$cert_password"

# Verificar se o arquivo PFX foi gerado corretamente
if [[ $? -ne 0 ]]; then
  echo "Erro ao converter os arquivos para formato PFX."
  rm -rf "$temp_folder"
  exit 1
fi

# Limpar a pasta temporária
rm -rf "$temp_folder"

echo "Conversão concluída. O arquivo $pfx_file foi gerado com sucesso."
