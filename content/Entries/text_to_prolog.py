import openai
import os
from textwrap import wrap

# Set up your OpenAI API key
openai.api_key = 'keyhere'

def split_text(text, chunk_size):
    """Split the text into chunks of specified size."""
    return wrap(text, chunk_size, break_long_words=False)

def call_gpt_api(chunk, prompt):
    """Call the GPT API with the given chunk and prompt."""
    try:
        response = openai.ChatCompletion.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": prompt},
                {"role": "user", "content": chunk}
            ]
        )
        return response.choices[0].message['content']
    except Exception as e:
        return f"Error: {str(e)}"

def process_text(input_file, output_file, chunk_size, prompt):
    """Process the input text file and save results to the output file."""
    with open(input_file, 'r') as f:
        text = f.read()
    
    chunks = split_text(text, chunk_size)
    
    with open(output_file, 'w') as f:
        for i, chunk in enumerate(chunks):
            print(f"Processing chunk {i+1}/{len(chunks)}")
            result = call_gpt_api(chunk, prompt)
            f.write(f"% Chunk {i+1}\n{result}\n\n")

# Example usage
input_file = 'input.txt'
output_file = 'output.txt'
chunk_size = 2000  # Adjust this based on your needs and API limitations
prompt = '''can you parse concepts and relationships from this text into prolog code? Please use the predicates below.  When a predicate is missing, create a new one of arity 1 or 2. You will likely need to create more relations of arity 2. Please respond with prolog code only.

abstract_concept/1
physical_entity/1
country/1
person/1
theoretical_framework/1
model/1

parent/2
category/2
property/2
has/2
contributes/2

Text:'''

process_text(input_file, output_file, chunk_size, prompt)
