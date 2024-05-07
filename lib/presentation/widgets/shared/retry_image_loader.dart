import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RetryImageLoader extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;

  const RetryImageLoader({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  RetryImageLoaderState createState() => RetryImageLoaderState();
}

class RetryImageLoaderState extends State<RetryImageLoader> {
  bool _loading = true;
  bool _error = false;
  int _retryAttempts = 0;
  final int maxRetryAttempts = 3; // Número máximo de intentos de reintentos
  final Duration retryDelay =
      const Duration(seconds: 5); // Intervalo de reintentos

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    setState(() {
      _loading = true;
      _error = false;
    });

    try {
      CachedNetworkImageProvider(widget.imageUrl)
          .resolve(const ImageConfiguration())
          .addListener(
            ImageStreamListener((info, _) {
              setState(() {
                _loading = false;
              });
            }, onError: (dynamic error, stackTrace) {
              _retryLoadImage();
            }),
          );
    } catch (e) {
      _retryLoadImage();
    }
  }

  void _retryLoadImage() {
    setState(() {
      _retryAttempts++;
      _loading = false;
      _error = true;
    });

    if (_retryAttempts < maxRetryAttempts) {
      // Programar un nuevo intento de carga después de un intervalo de tiempo
      Timer(retryDelay, () {
        if (mounted) {
          _loadImage();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const CircularProgressIndicator() // Muestra un indicador de carga mientras se intenta cargar la imagen
        : _error
            ? const Text(
                'Error cargando la imagen') // Muestra un mensaje de error si la carga falla después de los reintentos
            : CachedNetworkImage(
                imageUrl: widget.imageUrl,
                width: widget.width,
                height: widget.height,
                fit: BoxFit.cover,
              );
  }
}
