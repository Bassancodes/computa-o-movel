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
  return (
    <View style={styles.page}>
      <Text style={styles.heading}>Registro</Text>
      <TextInput
        placeholder="Nome de Usuário"
        value={username}
        onChangeText={setUsername}
        style={styles.input}
      />
      <TextInput
        placeholder="Senha"
        secureTextEntry
        value={password}
        onChangeText={setPassword}
        style={styles.input}
      />
      <Button title="Registrar" onPress={handleRegister} color="#3498db" />
    </View>
  );
};

// Login
const LoginScreen = ({ navigateTo, registeredUser, setIsLoggedIn }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = () => {
    if (registeredUser && username === registeredUser.username && password === registeredUser.password) {
      Alert.alert('Login bem-sucedido!');
      setIsLoggedIn(true);
      navigateTo('Home');
    } else {
      Alert.alert('Usuário ou senha incorretos.');
    }
  };

  return (
    <View style={styles.page}>
      <Text style={styles.heading}>Login</Text>
      <TextInput
        placeholder="Nome de Usuário"
        value={username}
        onChangeText={setUsername}
        style={styles.input}
      />
      <TextInput
        placeholder="Senha"
        secureTextEntry
        value={password}
        onChangeText={setPassword}
        style={styles.input}
      />
      <Button title="Entrar" onPress={handleLogin} color="#3498db" />
    </View>
  );
};

// Tela de Produtos 
const ShopScreen = ({ addToCart, navigateTo }) => {
  const medicines = [
    {
      id: '1',
      name: 'Paracetamol',
      image: 'https://cdn1.staticpanvel.com.br/produtos/15/156550-15.jpg?ims=424x',
      price: 5.00,
    },
    {
      id: '2',
      name: 'Ibuprofeno',
      image: 'https://santaluciadrogaria.vtexassets.com/arquivos/ids/155986/7898148295159.png?v=637637945204100000',
      price: 7.50,
    },
    {
      id: '3',
      name: 'Amoxicilina',
      image: 'https://maxxieconomica.com/storage/photos/1/Products/ean/7896004702223.jpg',
      price: 12.00,
    },
  ];
