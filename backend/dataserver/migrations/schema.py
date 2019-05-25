import glob
ups = glob.glob("*-up.cql")

out = ''
ups = sorted(ups)
print(ups)

for up in ups:
    with open(up) as file:
        out += file.read() + '\n'

with open('schema.cql', 'w') as file:
    file.write(out)
