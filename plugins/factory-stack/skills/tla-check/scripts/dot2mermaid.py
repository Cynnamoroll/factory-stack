#!/usr/bin/env python3
"""Convert a TLC `-dump dot,actionlabels` state graph to a Mermaid state diagram."""
import re
import sys

NODE = re.compile(r'^\s*(-?\d+)\s*\[label="(.*?)"(.*)\]\s*;?\s*$')
EDGE = re.compile(r'^\s*(-?\d+)\s*->\s*(-?\d+)\s*(?:\[(.*)\])?\s*;?\s*$')
LABEL = re.compile(r'label="(.*?)"')


def clean(label: str) -> str:
    parts = [p.strip() for p in label.replace('\\n', '\n').split('\n')]
    parts = [re.sub(r'^/\\\\\s*', '', p) for p in parts if p]
    text = ', '.join(parts)
    return text.replace('"', "'").replace('\\\\', '\\')


def main(path: str) -> None:
    nodes: dict[str, tuple[str, bool]] = {}
    edges: list[tuple[str, str, str]] = []
    with open(path) as handle:
        for line in handle:
            edge = EDGE.match(line)
            if edge:
                src, dst, attrs = edge.groups()
                found = LABEL.search(attrs or '')
                edges.append((src, dst, found.group(1) if found else ''))
                continue
            node = NODE.match(line)
            if node:
                key, label, rest = node.groups()
                nodes[key] = (clean(label), 'filled' in rest)
    ids = {key: f's{i}' for i, key in enumerate(nodes)}
    print('stateDiagram-v2')
    for key, (label, _) in nodes.items():
        print(f'    state "{label}" as {ids[key]}')
    for key, (_, initial) in nodes.items():
        if initial:
            print(f'    [*] --> {ids[key]}')
    seen = set()
    for src, dst, action in edges:
        if src not in ids or dst not in ids or src == dst:
            continue
        item = (src, dst, action)
        if item in seen:
            continue
        seen.add(item)
        suffix = f' : {action}' if action else ''
        print(f'    {ids[src]} --> {ids[dst]}{suffix}')


if __name__ == '__main__':
    main(sys.argv[1])
