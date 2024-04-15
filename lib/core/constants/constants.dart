/// `APP CONSTANTS`
class Defaults {
  Defaults._();

  static const avatar =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static const banner =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
}

/// `GLOBAL CONSTANTS`

const double kBR = 16;
const double kBannerHeight = 170;

/// `FIRESTORE COLLECTION KEYS`
class FireKeys {
  FireKeys._();

  static const users = 'users';
  static const posts = 'posts';
  static const comments = 'comments';
  static const communities = 'communities';
}

/// `GET STORAGE KEYS`
class BoxKeys {
  BoxKeys._();

  static const user = 'CURRENT_USER_MODEL';
  static const isDark = 'IS_DARK_THEME';
}
