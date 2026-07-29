class UniverseStar {
  const UniverseStar({
    required this.id,
    required this.x,
    required this.y,
    required this.size,
    required this.date,
    required this.time,
    required this.message,
  })  : assert(id != ''),
        assert(size > 0),
        assert(date != ''),
        assert(time != ''),
        assert(message != '');

  /// Identificador único da estrela.
  final String id;

  /// Posição horizontal dentro do universo virtual.
  final double x;

  /// Posição vertical dentro do universo virtual.
  final double y;

  /// Tamanho visual da estrela.
  ///
  /// Não representa importância ou prioridade.
  final double size;

  /// Data vinculada ao momento.
  ///
  /// Exemplo: 14/02/2019
  final String date;

  /// Horário vinculado ao momento.
  ///
  /// Exemplo: 21:37
  final String time;

  /// Mensagem favoritada do WhatsApp.
  final String message;
}