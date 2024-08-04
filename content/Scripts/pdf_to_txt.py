import sys
from pypdf import PdfReader

def pdf_to_txt(pdf_path, txt_path):
    with open(pdf_path, 'rb') as pdf_file, open(txt_path, 'w', encoding='utf-8') as txt_file:
        pdf_reader = PdfReader(pdf_file)
        for page in pdf_reader.pages:
            txt_file.write(page.extract_text())

if len(sys.argv) < 3:
    print("Usage: python pdf_to_txt.py input_pdf output_txt")
    sys.exit(1)

pdf_path = sys.argv[1]
txt_path = sys.argv[2]

pdf_to_txt(pdf_path, txt_path)
