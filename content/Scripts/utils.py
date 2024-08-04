import os
import re
from textwrap import wrap
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

client = OpenAI(
    api_key=os.getenv("OPENAI_API_KEY"),
)

def file_to_chunks(input_file, chunk_size):
    """Split the input text file into chunks of specified size."""
    with open(input_file, 'r') as f:
        text = f.read()
    
    return wrap(text, chunk_size, break_long_words=False)

def call_gpt_api(chunk, prompt):
    """Call the GPT API with the given chunk and prompt."""
    try:
        response = client.chat.completions.create(
        messages=[
        {
            "role": "system",
            "content": prompt
        },
        {
            "role": "user",
            "content": chunk
        }
        ],
        model="gpt-4o-mini",
        )
        return response.choices[0].message.content
    except Exception as e:
        return f"Error: {str(e)}"

def relation_correctness_check(text, prolog_code, prompt):
    correctness_check_prompt = f'''{prompt}

    Prolog Code:
    {prolog_code}

    Original Text:'''

    return call_gpt_api(text, correctness_check_prompt)

def text_to_relations(chunks, output_file, prompt, correctness_check_prompt):
    """Extract relations from a list of chunks and save to output file."""
    complete_output = ""
    with open(output_file, 'w') as f:
        for i, chunk in enumerate(chunks):
            print(f"Processing relations chunk {i+1}/{len(chunks)}")
            preliminary_result = call_gpt_api(chunk, prompt)
            result = relation_correctness_check(chunk, preliminary_result, correctness_check_prompt)
            f.write(f"% Chunk {i+1}\n{result}\n\n")
            complete_output += result + "\n"
    
    return complete_output

def prolog_predicates_to_entities(predicates, output_file):
    """Convert a list of Prolog predicates to entities and save to output file."""
    entity_predicates_arity_1 = predicates[0]
    entity_predicates_arity_2 = predicates[1]

    entity_list = []

    for predicate, parameters in entity_predicates_arity_1.items():
        for parameter in parameters:
            entity_list.append(parameter)

    for predicate, param1, param2 in entity_predicates_arity_2:
        entity_list.append(param1)
        entity_list.append(param2)

    entity_list = list(set(entity_list)) # Remove duplicates
    
    with open(output_file, 'w') as f:
        for entity in entity_list:
            f.write(f"{entity}.\n")

def entities_to_categorized_entities(chunks, output_file, prompt):
    """Categorize a list of entities using Prolog predicates and save to output file."""
    complete_output = ""
    with open(output_file, 'w') as f:
        for i, chunk in enumerate(chunks):
            print(f"Processing entities chunk {i+1}/{len(chunks)}")
            result = call_gpt_api(chunk, prompt)
            f.write(f"% Chunk {i+1}\n{result}\n\n")
            complete_output += result + "\n"
    
    return complete_output

def parse_prolog_file(file_path):
    content = read_file(file_path)
    return parse_prolog_predicates(content)
    
def parse_prolog_predicates(content):
    arity_1_predicates = {}
    arity_2_predicates = []
    
    # Parse arity 1 predicates
    for match in re.finditer(r'(\w+)\((\w+)\)\.', content):
        predicate, parameter = match.groups()
        if predicate not in arity_1_predicates:
            arity_1_predicates[predicate] = set()
        arity_1_predicates[predicate].add(parameter)

    # Parse arity 2 predicates
    for match in re.finditer(r'(\w+)\((\w+),\s*(\w+)\)\.', content):
        predicate, param1, param2 = match.groups()
        arity_2_predicates.append((predicate, param1, param2))

    return arity_1_predicates, arity_2_predicates

def read_file(file_path):
    with open(file_path, 'r') as file:
        return file.read()