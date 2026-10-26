# Benchmarks and Model Notes

## Lab results

Tests used the same prompt on the Ubuntu VM:

```text
write exactly 1000 words about a dystopian future where organic pumpkin-based computing has taken over the world.
```

Observed wall-clock results:

- `qwen2.5:7b`: `2m3.040s`
- `qwen2.5:3b`: `0m50.380s`

Based on wall-clock time alone, the 3B run completed approximately 2.44 times faster than the 7B run. The generated outputs were not guaranteed to contain exactly 1,000 words, so these wall-clock results should not be treated as exact tokens-per-second measurements.

An Ollama service log during a separate generation displayed an internal generation rate around 32 tokens per second. Record future results directly from Ollama's timing output or API metadata rather than estimating token count from word count.

## Repeatable API benchmark

Use the non-streaming Ollama API so the final JSON includes `eval_count` and `eval_duration`:

```bash
curl -s http://localhost:11434/api/generate \
  -d '{
    "model": "qwen2.5:3b",
    "prompt": "Write a detailed explanation of how reusing older computers can reduce electronic waste.",
    "stream": false,
    "options": {
      "temperature": 0
    }
  }' > result-3b.json
```

Tokens per second is:

```text
eval_count / (eval_duration / 1,000,000,000)
```

Use the same prompt and settings for every model and machine. Run once to warm the model, then record several subsequent runs.

## Results template

| Date | Hardware | Model | Quantization | Prompt tokens | Generated tokens | Eval duration | Tokens/sec | Notes |
|---|---|---|---|---:|---:|---:|---:|---|
| | | | | | | | | |

## Practical observations

- The 3B model responded much faster on the test VM.
- The 7B model used more memory and took longer.
- Smaller local models can produce confident but incorrect commands or lose the user's intent.
- Raw speed and answer quality should be evaluated separately.
