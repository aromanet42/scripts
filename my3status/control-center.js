module.exports = () => {
  return {
    name: 'control-center',
    full_text: '💻',
    _onclick: 'XDG_CURRENT_DESKTOP=GNOME gnome-control-center'
  };
};
