#!/usr/bin/env python3

def main():
    import torch
    print(torch.cuda.is_available())

if __name__ == '__main__':
    main()