// import 'package:flutter/material.dart';
// import 'package:flutter_html/src/html_elements.dart';
// import 'package:flutter_html/style.dart';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

import '../style.dart';
import 'styled_element.dart';
// import 'styled_element.dart';

/// An [InteractableElement] is a [StyledElement] that takes user gestures (e.g. tap).
class InteractableElement extends StyledElement {
  InteractableElement({
    String name,
    List<StyledElement> children,
    Style style,
    this.href,
    dom.Node node,
  }) : super(name: name, children: children, style: style, node: node);

  String href;
}

/// A [Gesture] indicates the type of interaction by a user.
enum Gesture {
  TAP,
}

InteractableElement parseInteractableElement(
    dom.Element element, List<StyledElement> children) {
  final interactableElement = InteractableElement(
    name: element.localName,
    children: children,
    node: element,
  );

  switch (element.localName) {
    case 'a':
      interactableElement.href = element.attributes['href'];
      interactableElement.style = Style(
        color: Colors.blue,
        textDecoration: TextDecoration.underline,
      );
      break;
  }

  return interactableElement;
}
