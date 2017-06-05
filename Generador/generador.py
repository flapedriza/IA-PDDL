import argparse
import random
import uuid

PLATS_PRIMER = 26
PLATS_SEGON = 22


class Plat:
    nom = None
    tipus = None
    preu = None
    cal = None

    def __init__(self, nom, tipus, preu, cal):
        self.nom = nom.strip().replace(' ', '_')
        self.tipus = tipus.strip()
        self.preu = int(preu)
        self.cal = int(cal)

    def __str__(self):
        return '{0} - tipus: {1} - preu: {2} - cal: {3}'.format(
            self.nom,
            self.tipus,
            self.preu,
            self.cal
        )


def obte_primers(num):
    with open('primers.txt', 'r') as file:
        lines = file.readlines()
    lines = random.sample(lines, num)
    plats = []
    for line in lines:
        info_plat = line[:-1].split(',')
        plat = Plat(*info_plat)
        plats.append(plat)
    return plats


def obte_segons(num):
    with open('segons.txt', 'r') as file:
        lines = file.readlines()
    lines = random.sample(lines, num)
    plats = []
    for line in lines:
        info_plat = line[:-1].split(',')
        plat = Plat(*info_plat)
        plats.append(plat)
    return plats


def obte_template():
    with open('template.pddl', 'r') as templ:
        template = templ.read()
    return template


def llista_tipus(primers, segons):

    allp = primers + segons

    tipus = set()

    for plat in allp:
        tipus.add(plat.tipus)

    string_tipus = ''

    for tip in tipus:
        string_tipus += tip + ' '

    return string_tipus[:-1]


def llista_plats(primers, segons):
    allp = set(primers + segons)

    string_plats = ''

    for plat in allp:
        string_plats += plat.nom + ' '

    return string_plats[:-1]


def predicats_calories(primers, segons):
    allp = set(primers + segons)

    predicats = ''

    for plat in allp:
        pred = '\t\t(= (calorias_plato {0}) {1})\n'.format(plat.nom, plat.cal)
        predicats += pred

    return predicats[:-1]


def predicats_preus(primers, segons):
    allp = set(primers + segons)

    predicats = ''

    for plat in allp:
        pred = '\t\t(= (precio_plato {0}) {1})\n'.format(plat.nom, plat.preu)
        predicats += pred

    return predicats[:-1]


def predicats_primers(primers):
    predicats = ''

    for prim in primers:
        pred = '\t\t(primero {0})\n'.format(prim.nom)
        predicats += pred
    return predicats[:-1]


def predicats_tipus(primers, segons):
    allp = set(primers + segons)

    predicats = ''

    for plat in allp:
        pred = '\t\t(es_tipo {0} {1})\n'.format(plat.nom, plat.tipus)
        predicats += pred

    return predicats[:-1]


def genera_incompatibilitats(rand=False, primers=None, segons=None):
    incomp = []

    if rand:
        ninc = random.randint(0, len(primers))

        for _ in range(ninc):
            prim = random.choice(primers)
            seg = random.choice(segons)
            incomp.append((prim.nom, seg.nom))

    else:
        with open('incompatibles.txt', 'r') as file:
            lines = file.readlines()
        for line in lines:
            prim, seg = [plat.strip().replace(' ', '_')
                         for plat in line.split(',')]
            if any(x.nom == prim for x in primers) and any(x.nom == seg for x in segons):
                incomp.append((prim, seg))

    predicats = ''

    for prim, seg in incomp:
        pred = '\t\t(incomp {0} {1})\n'.format(prim, seg)
        predicats += pred

    return predicats



###############################
######### ARG PARSING #########
###############################
parser = argparse.ArgumentParser(description='Generador problemes PDDL menus')

parser.add_argument('--prim', '-p', help='Num primers', type=int,
                    default=random.randint(1, PLATS_PRIMER), required=False)

parser.add_argument('--seg', '-s', help='Num segons', type=int,
                    default=random.randint(1, PLATS_SEGON), required=False)

parser.add_argument(
    '--rand', '-r', help="Genera incompatibilitats a l'atzar", action='store_true')

parser.add_argument('--file', '-f', help='Nom del fitxer generat, si no s\'informa el nom del'
                    ' fitxer és aleatori', type=str,
                    default=str(uuid.uuid4()), required=False)


def main():
    parsed = parser.parse_args()
    nprim = parsed.prim
    nseg = parsed.seg
    prim = obte_primers(nprim)
    seg = obte_segons(nseg)
    incomp = genera_incompatibilitats(parsed.rand, prim, seg)
    template = obte_template()

    template = template.format(
        llista_tipus(prim, seg),
        llista_plats(prim, seg),
        predicats_calories(prim, seg),
        predicats_preus(prim, seg),
        predicats_primers(prim),
        incomp,
        predicats_tipus(prim, seg)
    )

    print('Se ha generado un juego de pruebas con'
          ' {0} primeros, {1} segundos y {2} incompatibilidades'
          .format(nprim, nseg, len(incomp.split('\n'))))

    with open(parsed.file + '.pddl', 'w') as file:
        file.write(template)


if __name__ == '__main__':
    main()
