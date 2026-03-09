def solve():
    for J in range(1, 8):
        K = 8 - J
        if K <= 0 or K % 3 != 0: continue
        G = K // 3
        F = 18 - J
        if F <= 0 or F % G != 0: continue
        R = F // G
        C = R - 3
        if C <= 0: continue
        
        print(f"J={J}, K={K}, G={G}, F={F}, R={R}, C={C}")

solve()
