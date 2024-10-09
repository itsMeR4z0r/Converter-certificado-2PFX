# Converter-certificado-2PFX

Este repositório contém um script Bash para converter certificados a partir de arquivos ZIP gerados pelo site [ZeroSSL](https://app.zerossl.com/) para o formato PFX. 

## Descrição

O script `convertCert.sh` realiza as seguintes tarefas:

1. Verifica se os comandos `unzip` e `openssl` estão disponíveis no sistema, instalando-os se necessário.
2. Solicita ao usuário o caminho do arquivo ZIP contendo os certificados.
3. Extrai o conteúdo do arquivo ZIP para uma pasta temporária.
4. Verifica se os arquivos necessários (`private.key`, `certificate.crt`, `ca_bundle.crt`) foram extraídos corretamente.
5. Solicita ao usuário a senha para o certificado.
6. Converte os arquivos extraídos para o formato PFX usando a senha fornecida.
7. Salva o arquivo PFX gerado no mesmo diretório do arquivo ZIP original com um nome baseado na data atual.
8. Limpa a pasta temporária usada durante o processo.

## Como usar

1. Clone este repositório para o seu ambiente local.
2. Torne o script executável:
    ```bash
    chmod +x convertCert.sh
    ```
3. Execute o script:
    ```bash
    ./convertCert.sh
    ```
4. Siga as instruções fornecidas pelo script para converter seu certificado.

## Exemplo de uso

```bash
./convertCert.sh
```
Durante a execução, você será solicitado a fornecer o caminho do arquivo ZIP e uma senha para o certificado. O script gerará um arquivo PFX no mesmo diretório do arquivo ZIP original.

## Dependências

O script depende dos seguintes comandos:

- `unzip`
- `openssl`

Se esses comandos não estiverem disponíveis no seu sistema, o script tentará instalá-los automaticamente.
