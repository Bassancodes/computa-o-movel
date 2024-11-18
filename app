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
  return (
    <View style={styles.page}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigateTo('Home')}>
          <Text style={styles.backButton}>←</Text>
        </TouchableOpacity>
        <Text style={styles.subheading}>Mercado de Remédios</Text>
      </View>
      <View style={styles.medicineList}>
        {medicines.map((medicine) => (
          <View key={medicine.id} style={styles.medicineItem}>
            <Image
              source={{ uri: medicine.image }}
              style={styles.medicineImage}
            />
            <Text style={styles.medicineName}>{medicine.name}</Text>
            <Text style={styles.medicinePrice}>Preço: R$ {medicine.price.toFixed(2)}</Text>
            <Button title="Comprar" onPress={() => addToCart(medicine)} color="#3498db" />
          </View>
        ))}
      </View>
    </View>
  );
};
//Carrinho de Compras
const CartScreen = ({ cart, navigateTo }) => {
  const totalPrice = cart.reduce((acc, item) => acc + item.price * item.quantity, 0);

  return (
    <View style={styles.page}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigateTo('Home')}>
          <Text style={styles.backButton}>←</Text>
        </TouchableOpacity>
        <Text style={styles.subheading}>Carrinho de Remédios</Text>
      </View>
      {cart.length === 0 ? (
        <Text>Seu carrinho está vazio.</Text>
      ) : (
        <View style={styles.cartList}>
          {cart.map((item, index) => (
            <View key={index} style={styles.cartItem}>
              <Image source={{ uri: item.image }} style={styles.cartImageSmall} />
              <View style={styles.cartItemDetails}>
                <Text style={styles.cartItemName}>{item.name}</Text>
                <Text style={styles.cartItemQuantity}>Quantidade: {item.quantity}</Text>
                <Text style={styles.cartItemPrice}>Preço: R$ {(item.price * item.quantity).toFixed(2)}</Text>
              </View>
            </View>
          ))}
          <Text style={styles.totalPrice}>Total: R$ {totalPrice.toFixed(2)}</Text>
        </View>
      )}
    </View>
  );
};

const QueueScreen = ({ navigateTo }) => {
  const [inQueue, setInQueue] = useState(false);
  const [queuePosition, setQueuePosition] = useState(null);
  const [waitingTime, setWaitingTime] = useState(null);
  const [timeLeft, setTimeLeft] = useState(null);
  const [message, setMessage] = useState("");
  const [sound, setSound] = useState();

  const enterQueue = () => {
    const position = Math.floor(Math.random() * 100) + 1;
    const time = Math.floor(Math.random() * 10) + 5;

    setQueuePosition(position);
    setWaitingTime(time);
    setTimeLeft(time);
    setInQueue(true);
    setMessage(`Você está na posição ${position} da fila. Tempo estimado: ${time} segundos.`);
  };

  useEffect(() => {
    if (inQueue && timeLeft > 0) {
      const timer = setInterval(() => {
        setTimeLeft((prev) => prev - 1);
      }, 1000);

      return () => clearInterval(timer);
    } else if (inQueue && timeLeft === 0) {
      playSound();
      setMessage(`Sua vez chegou! Por favor, dirija-se à sala ${Math.floor(Math.random() * 10) + 1} para consulta com o Dra. Giovanna Momozi Garcia.`);
      setInQueue(false);
    }
  }, [inQueue, timeLeft]);

  async function playSound() {
    const { sound } = await Audio.Sound.createAsync(
      require('./assets/car-warning-sound-2-189737.mp3') // Certifique-se de que o arquivo está na pasta 'assets'
    );
    setSound(sound);
    await sound.playAsync();
  }

  useEffect(() => {
    return sound
      ? () => {
          sound.unloadAsync();
        }
      : undefined;
  }, [sound]);

  return (
    <View style={styles.page}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigateTo('Home')}>
          <Text style={styles.backButton}>←</Text>
        </TouchableOpacity>
        <Text style={styles.subheading}>Fila de Espera</Text>
      </View>
      <View style={styles.queueContent}>
        {inQueue ? (
          <Text>{message}{'\n'}Tempo restante: {timeLeft} segundos</Text>
        ) : (
          <>
            <Text>{message || "Clique em 'Entrar na Fila' para iniciar o processo."}</Text>
            <Button title="Entrar na Fila" onPress={enterQueue} color="#3498db" />
          </>
        )}
      </View>
    </View>
  );
};
// carrinho de compras
const App = () => {
  const [activePage, setActivePage] = useState('Home');
  const [registeredUser, setRegisteredUser] = useState(null);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [cart, setCart] = useState([]);

  const navigateTo = (page) => setActivePage(page);

  const handleLogout = () => {
    setIsLoggedIn(false);
    navigateTo('Login');
  };

  const addToCart = (medicine) => {
    const existingItem = cart.find((item) => item.id === medicine.id);

    if (existingItem) {
      setCart(
        cart.map((item) =>
          item.id === medicine.id ? { ...item, quantity: item.quantity + 1 } : item
        )
      );
    } else {
      setCart([...cart, { ...medicine, quantity: 1 }]);
    }
    Alert.alert(`${medicine.name} adicionado ao carrinho!`);
  };

  const renderPage = () => {
    switch (activePage) {
      case 'Home':
        return <HomeScreen />;
      case 'Register':
        return <RegisterScreen navigateTo={navigateTo} setRegisteredUser={setRegisteredUser} />;
      case 'Login':
        return <LoginScreen navigateTo={navigateTo} registeredUser={registeredUser} setIsLoggedIn={setIsLoggedIn} />;
      case 'Shop':
        return <ShopScreen addToCart={addToCart} navigateTo={navigateTo} />;
      case 'Cart':
        return <CartScreen cart={cart} navigateTo={navigateTo} />;
      case 'Queue':
        return <QueueScreen navigateTo={navigateTo} />;
      default:
        return <HomeScreen />;
    }
  };

  return (
    <View style={styles.app}>
      <View style={styles.content}>
        {renderPage()}
      </View>
      <View style={styles.navbar}>
        {isLoggedIn ? (
          <>
            <Button title="Sair" onPress={handleLogout} />
            <Button title="Shop" onPress={() => navigateTo('Shop')} />
            <Button title="Carrinho" onPress={() => navigateTo('Cart')} />
            <Button title="Fila" onPress={() => navigateTo('Queue')} />
          </>
        ) : (
          <>
            <Button title="Login" onPress={() => navigateTo('Login')} />
            <Button title="Registrar" onPress={() => navigateTo('Register')} />
          </>
        )}
      </View>
    </View>
  );
};

// Estilos
const styles = StyleSheet.create({
  app: {
    flex: 1,
    backgroundColor: '#f5f8fa',
    fontFamily: 'Arial',
  },
  content: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  page: {
    textAlign: 'center',
    padding: 20,
    borderRadius: 8,
    backgroundColor: '#ffffff',
    maxWidth: 600,
    width: '100%',
  },
  heading: {
    color: '#2c3e50',
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  subheading: {
    color: '#34495e',
    fontSize: 20,
    fontWeight: 'bold',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  backButton: {
    fontSize: 24,
    color: '#3498db',
  },
  input: {
    width: '100%',
    marginVertical: 10,
    padding: 10,
    fontSize: 16,
    borderColor: '#bdc3c7',
    borderWidth: 1,
    borderRadius: 4,
  },
  medicineList: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-around',
  },
  medicineItem: {
    alignItems: 'center',
    padding: 15,
    borderColor: '#ddd',
    borderWidth: 1,
    borderRadius: 8,
    width: '30%',
    margin: 5,
  },
  medicineImage: {
    width: 70,
    height: 100,
    marginBottom: 10,
  },
  medicineName: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#34495e',
  },
  medicinePrice: {
    color: '#555',
    fontSize: 14,
  },
  cartList: {
    paddingTop: 20,
  },
  cartItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
  },
  cartImageSmall: {
    width: 40,
    height: 60,
    borderRadius: 8,
  },
  cartItemDetails: {
    marginLeft: 10,
  },
  cartItemName: {
    fontWeight: 'bold',
    color: '#2c3e50',
    fontSize: 14,
  },
  totalPrice: {
    marginTop: 20,
    fontWeight: 'bold',
    fontSize: 18,
    color: '#34495e',
  },
  queueContent: {
    fontSize: 18,
    color: '#2c3e50',
    marginTop: 20,
  },
  navbar: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    paddingVertical: 10,
    backgroundColor: '#2c3e50',
  },
});

export default App;
