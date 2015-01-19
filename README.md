# Zoomable

This is meant to demonstrate some difficulties I'm having with zooming with UIScrollView.

The UIScrollView contains a UITextView and UIImageView, and I would like the UIImageView to be zoomable, but not the UITextView.

When the UIScrollView is partially scrolled (contentOffset.y > 0.0), performing a pinch to zoom causes a noticeable jump.
