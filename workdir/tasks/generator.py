import torch
from transformers import pipeline
import pandas as pd

generator = pipeline('text-generation', device=0, model="rinna/japanese-gpt-neox-3.6b")
text = "こんにちは!"
max_length = 200

outputs = generator(text, max_length=max_length)

print(outputs[0]['generated_text'])
