import random
import sys
import argparse
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
        self.preu = preu
        self.cal = cal

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
        string_tipus += tip+' '

    return string_tipus[:-1]

def llista_plats(primers, segons):
    allp = set(primers + segons)

    string_plats = ''

    for plat in allp:
        string_plats += plat.nom+' '

    return string_plats[:-1]

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

def genera_incompatibilitats(random=False):
    return ''


###############################
######### ARG PARSING #########
###############################
parser = argparse.ArgumentParser(description='Generador problemes PDDL menus')

parser.add_argument('--prim', '-p', help='Num primers', type=int,
                    default=random.randint(1, PLATS_PRIMER), required=False)

parser.add_argument('--seg', '-s', help='Num segons', type=int,
                    default=random.randint(1, PLATS_SEGON), required=False)

parser.add_argument('--rand', '-r', help="Genera incompatibilitats a l'atzar", action='store_true')

parser.add_argument('--file', '-f', help='Nom del fitxer generat', type=str,
                    default=str(uuid.uuid4()), required=False)



def main():
    parsed = parser.parse_args()
    nprim = parsed.prim
    nseg = parsed.seg
    prim = obte_primers(nprim)
    seg = obte_segons(nseg)

    template = obte_template()

    template = template.format(
        llista_tipus(prim, seg),
        llista_plats(prim, seg),
        predicats_primers(prim),
        '',
        predicats_tipus(prim, seg)
    )

    print('Se ha generado un juego de pruebas con'
          ' {0} primeros, {1} segundos y {2} incompatibilidades'.format(nprim, nseg, 0))

    with open(parsed.file+'.pddl', 'w') as file:
        file.write(template)



    

if __name__ == '__main__':
    main()