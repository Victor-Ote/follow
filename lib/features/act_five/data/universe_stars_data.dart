import 'universe_star.dart';

int get universeStarCount => universeStars.length;

/// Fonte única de dados das estrelas do ATO V.
///
/// As posições utilizam coordenadas do universo virtual,
/// e não coordenadas relativas à tela do aparelho.
///
/// Novas estrelas deverão ser adicionadas exclusivamente
/// nesta lista.
const List<UniverseStar> universeStars = [
  UniverseStar(
    id: 'star-001',
    x: 0,
    y: 0,
    size: 3.2,
    date: '14/02/2019',
    time: '21:37',
    message: 'Eu te amo.',
  ),
  UniverseStar(
    id: 'star-002',
    x: 180,
    y: -240,
    size: 2.4,
    date: '20/03/2019',
    time: '09:18',
    message: 'Mensagem favoritada.',
  ),
  UniverseStar(
    id: 'star-003',
    x: -260,
    y: 170,
    size: 3.4,
    date: '08/06/2019',
    time: '18:42',
    message: 'Outra mensagem favoritada.',
  ),
  UniverseStar(
    id: 'star-004',
    x: 620,
    y: 340,
    size: 2.8,
    date: '15/09/2019',
    time: '22:05',
    message: 'Outra mensagem.',
  ),
  UniverseStar(
    id: 'star-005',
    x: -750,
    y: -420,
    size: 2.2,
    date: '01/01/2020',
    time: '00:08',
    message: 'Outra mensagem.',
  ),
];