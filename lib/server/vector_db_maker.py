from PyPDF2 import PdfReader
import os
from bs4 import BeautifulSoup
from langchain_community.vectorstores import Chroma
from langchain_community import embeddings
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.document_loaders import WebBaseLoader
import requests
from urllib.parse import urlparse, urljoin


async def get_text(pdfs, directory_name):
    text = ""
    for pdf in pdfs:
        pdf_reader = PdfReader(pdf.filename)
        for page in pdf_reader.pages:
            text += page.extract_text()

        os.remove(pdf.filename)

    text_splitter = CharacterTextSplitter(
        separator="\n",
        chunk_size=3000,
        chunk_overlap=1000,
        length_function = len
    )

    chunks = text_splitter.split_text(text)

    Chroma.from_texts(
        texts=chunks,
        persist_directory=directory_name,
        embedding=embeddings.OllamaEmbeddings(model='nomic-embed-text'),
    )


def get_all_link(url):
    # Ottenere il contenuto HTML della pagina
    response = requests.get(url)
    # Verifica se la richiesta ha avuto successo
    if response.status_code == 200:
        # Parsing del contenuto HTML
        soup = BeautifulSoup(response.content, 'html.parser')

        base_domain = urlparse(url).netloc

        # Estrazione di tutti i tag 'a' (link)
        links = soup.find_all('a',href=True)
        # Lista per memorizzare gli URL dei link
        all_links = []
        for link in links:
            # Ottenere l'attributo 'href' degli elementi 'a'
            href = link.get('href')

            full_url = urljoin(url,href)

            # Verifica se l'URL è valido
            if urlparse(full_url).netloc == base_domain:
                # Aggiungi l'URL all lista dei link
                all_links.append(full_url)
        return all_links
    else:
        # Se la richiesta non ha successo, stampa un messaggio di errore
        print("Errore durante la richiesta HTTP:", response.status_code)
        return []

def get_all_urls(urls_list):
    urls = []

    for url in urls_list:
        urls.append(url)
        links = get_all_link(url)
        urls.extend(links)

    return urls

def get_content_from_url(url):
    try:
        content = WebBaseLoader(url).load()
    except Exception:
        return None
    
    return content


async def urls_vectordb_maker(urls,directory_name):

    docs = []

    # Convert string of URLs to list
    urls_list = urls.split("\n")
    urls_list= get_all_urls(urls_list)
    for url in urls_list:
        content = get_content_from_url(url)
        if content:
            docs.append(content)
    #docs = [WebBaseLoader(url).load() for url in urls_list]
    docs_list = [item for sublist in docs for item in sublist]
    
    #split the text into chunks
    
    text_splitter = CharacterTextSplitter.from_tiktoken_encoder(chunk_size=7500, chunk_overlap=100)
    doc_splits = text_splitter.split_documents(docs_list)
    
    #convert text chunks into embeddings and store in vector database

    Chroma.from_documents(
        documents=doc_splits,
        persist_directory=directory_name,
        embedding=embeddings.OllamaEmbeddings(model='nomic-embed-text'),
    )

