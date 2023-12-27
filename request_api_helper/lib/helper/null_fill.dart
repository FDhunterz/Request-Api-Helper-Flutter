class NullFill {
  NullFill.state();

  converter(newValue, baseValue) {
    if (newValue != null) return newValue;
    return baseValue;
  }
}
