import { Dimensions, Platform, PixelRatio } from 'react-native';

const {
  width: SCREEN_WIDTH,
  height: SCREEN_HEIGHT,
} = Dimensions.get('window');

const scale = SCREEN_WIDTH / 375;

export function normalize(size: number) {
  const newSize = size * scale
  if (Platform.OS === 'ios') {
    return Math.round(PixelRatio.roundToNearestPixel(newSize))
  } else {
    return Math.round(PixelRatio.roundToNearestPixel(newSize)) - 2
  }
}

export const colorPrimary = '#616161'
export const colorLightPrimary = '#eeeeee'
export const colorText = '#212121'
export const colorAccent = '#f50057'
export const colorSecondText = '#757575'
export const colorBg= '#8D999E'
export const colorDivider = '#BDBDBD'
export const colorWhite = '#fff'

export function shadow(color: string) {
  return {
    shadowRadius: 2,
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowColor: color,
    shadowOpacity: 0.5,
    elevation: 4,
  }
}
