import requests
from bs4 import BeautifulSoup
from urllib.parse import urlparse, urljoin

def get_same_domain_links(url):
    # Ottieni il contenuto HTML della pagina
    response = requests.get(url)
    
    # Controlla che la richiesta sia andata a buon fine
    if response.status_code == 200:
        # Analizza il contenuto HTML
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Ottieni il dominio base dell'URL passato
        base_domain = urlparse(url).netloc
        
        # Trova tutti i tag 'a' che contengono i link
        links = soup.find_all('a', href=True)
        
        # Lista per salvare i link con la stessa radice dell'URL passato
        same_domain_links = []
        
        for link in links:
            # Ottieni l'URL completo del link
            href = link['href']
            
            # Unisci l'URL relativo con l'URL di base per ottenere l'URL completo
            full_url = urljoin(url, href)
            
            # Controlla se l'URL appartiene allo stesso dominio dell'URL passato
            if urlparse(full_url).netloc == base_domain:
                same_domain_links.append(full_url)
        
        return same_domain_links
    else:
        # Se la richiesta non è andata a buon fine, restituisci una lista vuota
        return []

# Esempio di utilizzo
url = "https://it.wikipedia.org/wiki/Reggio_Emilia"
same_domain_links = get_same_domain_links(url)
print("Link con la stessa radice dell'URL passato:")
for link in same_domain_links:
    print(link)
