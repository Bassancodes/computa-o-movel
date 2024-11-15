import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, Button, Alert, Image, TouchableOpacity, StyleSheet } from 'react-native';
import { Audio } from 'expo-av';

const HomeScreen = () => (
  <View style={styles.page}>
    <Text style={styles.heading}>Bem-vindo ao Hospital</Text>
    <Text style={styles.text}>Aqui você poderá comprar remédios, visualizar seu carrinho de compras e entrar na nossa fila de espera para consulta.</Text>
  </View>
);

// Registro
const RegisterScreen = ({ navigateTo, setRegisteredUser }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleRegister = () => {
    if (username && password) {
      setRegisteredUser({ username, password });
      Alert.alert('Registro bem-sucedido! Agora você pode fazer login.');
      navigateTo('Login');
    } else {
      Alert.alert('Por favor, preencha todos os campos.');
    }
  };
