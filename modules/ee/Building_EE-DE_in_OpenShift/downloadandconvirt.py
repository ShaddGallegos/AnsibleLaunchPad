#!/usr/bin/env python3
"""
User-configurable variables - modify as needed
"""
import os
import getpass

# User configuration
USER = os.getenv('USER', getpass.getuser())
USER_EMAIL = os.getenv('USER_EMAIL', f"{USER}@{os.getenv('COMPANY_DOMAIN', 'example.com')}")
COMPANY_NAME = os.getenv('COMPANY_NAME', 'Your Company')
COMPANY_DOMAIN = os.getenv('COMPANY_DOMAIN', 'example.com')

import os
import requests
from urllib.parse import urljoin, urlparse
from bs4 import BeautifulSoup
import html2text

def sanitize_filename(url):
    return os.path.basename(urlparse(url).path) or "image.jpg"

def download_images(soup, base_url, image_folder="images"):
    os.makedirs(image_folder, exist_ok=True)
    for img in soup.find_all("img"):
        src = img.get("src")
        if not src:
            continue
        img_url = urljoin(base_url, src)
        filename = sanitize_filename(img_url)
        img_path = os.path.join(image_folder, filename)

        try:
            img_data = requests.get(img_url).content
            with open(img_path, "wb") as f:
                f.write(img_data)
            # Update img src to local path for Markdown
            img["src"] = os.path.join(image_folder, filename)
        except Exception as e:
            print(f"⚠️ Failed to download {img_url}: {e}")

def download_and_convert_to_markdown(url):
    try:
        response = requests.get(url)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, "html.parser")
        download_images(soup, url)

        html_content = str(soup)
        markdown = html2text.HTML2Text().handle(html_content)

        filename = "converted_page.md"
        with open(filename, "w", encoding="utf-8") as file:
            file.write(markdown)

        print(f"\n✅ Page and images saved! Markdown: '{filename}', Images folder: 'images/'")
    except requests.exceptions.RequestException as e:
        print(f"\n❌ Error fetching the page: {e}")

if __name__ == "__main__":
    url = input("🌐 Enter the URL of the page to convert to Markdown with images: ")
    download_and_convert_to_markdown(url)

