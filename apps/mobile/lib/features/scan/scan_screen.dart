import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_receipt_mobile/features/scan/bloc/scan_bloc.dart';
import 'package:smart_receipt_mobile/features/scan/bloc/scan_event.dart';
import 'package:smart_receipt_mobile/features/scan/bloc/scan_state.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Escanear Ticket'),
        ),
        body: BlocBuilder<ScanBloc, ScanState>(
          builder: (context, state) {
            if (state is ScanLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ScanError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ScanBloc>().add(const ScanClearImage());
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (state is ScanImageSelected) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Imagen seleccionada
                    Card(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(state.imagePath),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Información del archivo
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Imagen seleccionada',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.imagePath,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Botón para subir
                    ElevatedButton(
                      onPressed: () {
                        context.read<ScanBloc>().add(
                          ScanUploadImage(state.imagePath),
                        );
                      },
                      child: const Text('Subir Imagen'),
                    ),
                    const SizedBox(height: 8),
                    // Botón para limpiar
                    OutlinedButton(
                      onPressed: () {
                        context.read<ScanBloc>().add(const ScanClearImage());
                      },
                      child: const Text('Seleccionar otra imagen'),
                    ),
                  ],
                ),
              );
            }

            if (state is ScanUploading) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Imagen que se está subiendo
                    Card(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.file(
                            File(state.imagePath),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Indicador de progreso
                    Column(
                      children: [
                        CircularProgressIndicator(
                          value: state.progress > 0 ? state.progress : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Subiendo imagen... ${(state.progress * 100).toInt()}%',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            if (state is ScanUploadSuccess) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Imagen subida
                    Card(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(state.imagePath),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Mensaje de éxito
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Imagen subida correctamente',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Botón para volver
                    ElevatedButton(
                      onPressed: () {
                        context.read<ScanBloc>().add(const ScanClearImage());
                      },
                      child: const Text('Escanear otro ticket'),
                    ),
                  ],
                ),
              );
            }

            // Estado inicial - Mostrar opciones
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Escanear Ticket',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toma una foto o selecciona una imagen de tu galería',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<ScanBloc>().add(const ScanOpenCamera());
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Abrir Cámara'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<ScanBloc>().add(const ScanOpenGallery());
                        },
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Abrir Galería'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
